import Foundation
import SystemPackage
import WasmParser

/// Parse a given file as a WebAssembly binary format file
/// > Note: <https://webassembly.github.io/spec/core/binary/index.html>
public func parseWasm(filePath: FilePath, features: WasmFeatureSet = .default) throws -> Module {
    let fileHandle = try FileHandle(forReadingFrom: URL(fileURLWithPath: filePath.string))
    defer { try? fileHandle.close() }
    let stream = try FileHandleStream(fileHandle: fileHandle)
    let module = try parseModule(stream: stream, features: features)
    return module
}

/// Parse a given byte array as a WebAssembly binary format file
/// > Note: <https://webassembly.github.io/spec/core/binary/index.html>
public func parseWasm(bytes: [UInt8], features: WasmFeatureSet = .default) throws -> Module {
    let stream = StaticByteStream(bytes: bytes)
    let module = try parseModule(stream: stream, features: features)
    return module
}


private struct OrderTracking {
    enum Order: UInt8 {
        case initial = 0
        case type
        case _import
        case function
        case table
        case memory
        case tag
        case global
        case export
        case start
        case element
        case dataCount
        case code
        case data
    }

    private var last: Order = .initial
    mutating func track(order: Order) throws {
        guard last.rawValue < order.rawValue else {
            throw WasmParserError.sectionOutOfOrder
        }
        last = order
    }
}

/// > Note:
/// <https://webassembly.github.io/spec/core/binary/modules.html#binary-module>
func parseModule<Stream: ByteStream>(stream: Stream, features: WasmFeatureSet = .default) throws -> Module {
    var module = Module()

    var orderTracking = OrderTracking()
    var typeIndices = [TypeIndex]()
    var codes = [Code]()
    var parser = WasmParser.Parser<Stream>(
        stream: stream, features: features
    )

    while let payload = try parser.parseNext() {
        switch payload {
        case .header: break
        case .customSection(let customSection):
            module.customSections.append(customSection)
        case .typeSection(let types):
            try orderTracking.track(order: .type)
            module.types = types
        case .importSection(let importSection):
            try orderTracking.track(order: ._import)
            module.imports = importSection
        case .functionSection(let types):
            try orderTracking.track(order: .function)
            typeIndices = types
        case .tableSection(let tableSection):
            try orderTracking.track(order: .table)
            module.tables = tableSection
        case .memorySection(let memorySection):
            try orderTracking.track(order: .memory)
            module.memories = memorySection
        case .globalSection(let globalSection):
            try orderTracking.track(order: .global)
            module.globals = globalSection
        case .exportSection(let exportSection):
            try orderTracking.track(order: .export)
            module.exports = exportSection
        case .startSection(let functionIndex):
            try orderTracking.track(order: .start)
            module.start = functionIndex
        case .elementSection(let elementSection):
            try orderTracking.track(order: .element)
            module.elements = elementSection
        case .codeSection(let codeSection):
            try orderTracking.track(order: .code)
            codes = codeSection
        case .dataSection(let dataSection):
            try orderTracking.track(order: .data)
            module.data = dataSection
        case .dataCount(let dataCount):
            try orderTracking.track(order: .dataCount)
            module.dataCount = dataCount
        }
    }

    guard typeIndices.count == codes.count else {
        throw WasmParserError.inconsistentFunctionAndCodeLength(
            functionCount: typeIndices.count,
            codeCount: codes.count
        )
    }

    if let dataCount = module.dataCount, dataCount != UInt32(module.data.count) {
        throw WasmParserError.inconsistentDataCountAndDataSectionLength(
            dataCount: dataCount,
            dataSection: module.data.count
        )
    }

    let translatorContext = InstructionTranslator.Module(
        typeSection: module.types,
        importSection: module.imports,
        functionSection: typeIndices,
        globalTypes: module.globals.map { $0.type },
        memoryTypes: module.memories.map { $0.type },
        tables: module.tables
    )
    let enableAssertDefault = _slowPath(getenv("WASMKIT_ENABLE_ASSERT") != nil)
    let functions = codes.enumerated().map { [hasDataCount = parser.hasDataCount, features] index, code in
        let funcTypeIndex = typeIndices[index]
        let funcType = module.types[Int(funcTypeIndex)]
        return GuestFunction(
            type: typeIndices[index], locals: code.locals,
            body: {
                var enableAssert = enableAssertDefault
                #if ASSERT
                enableAssert = true
                #endif
                
                var translator = InstructionTranslator(
                    allocator: module.allocator,
                    module: translatorContext,
                    type: funcType, locals: code.locals
                )

                if enableAssert && !_isFastAssertConfiguration() {
                    let globalFuncIndex = module.imports.count + index
                    print("🚀 Starting Translation for code[\(globalFuncIndex)] (\(funcType))")
                    var tracing = InstructionTracingVisitor(trace: {
                        print("🍵 code[\(globalFuncIndex)] Translating \($0)")
                    }, visitor: translator)
                    try WasmParser.parseExpression(
                        bytes: Array(code.expression),
                        features: features, hasDataCount: hasDataCount,
                        visitor: &tracing
                    )
                    let newISeq = InstructionSequence(instructions: tracing.visitor.finalize())
                    return newISeq
                }
                try WasmParser.parseExpression(
                    bytes: Array(code.expression),
                    features: features, hasDataCount: hasDataCount,
                    visitor: &translator
                )
                return InstructionSequence(instructions: translator.finalize())
            })
    }
    module.functions = functions

    return module
}