// This file is generated by Utilities/generate_inst_dispatch.swift
extension ExecutionState {
    @_transparent
    mutating func doExecute(_ instruction: Instruction, runtime: Runtime) throws {
        switch instruction {
        case .unreachable:
            try self.unreachable(runtime: runtime)
            return
        case .nop:
            try self.nop(runtime: runtime)
            return
        case .block(let endRef, let type):
            try self.block(runtime: runtime, endRef: endRef, type: type)
            return
        case .loop(let type):
            try self.loop(runtime: runtime, type: type)
            return
        case .ifThen(let endRef, let type):
            try self.ifThen(runtime: runtime, endRef: endRef, type: type)
            return
        case .ifThenElse(let elseRef, let endRef, let type):
            try self.ifThenElse(runtime: runtime, elseRef: elseRef, endRef: endRef, type: type)
            return
        case .end:
            try self.end(runtime: runtime)
            return
        case .`else`:
            try self.`else`(runtime: runtime)
            return
        case .br(let labelIndex):
            try self.br(runtime: runtime, labelIndex: labelIndex)
            return
        case .brIf(let labelIndex):
            try self.brIf(runtime: runtime, labelIndex: labelIndex)
            return
        case .brTable(let brTable):
            try self.brTable(runtime: runtime, brTable: brTable)
            return
        case .`return`:
            try self.`return`(runtime: runtime)
            return
        case .call(let functionIndex):
            try self.call(runtime: runtime, functionIndex: functionIndex)
            return
        case .callIndirect(let tableIndex, let typeIndex):
            try self.callIndirect(runtime: runtime, tableIndex: tableIndex, typeIndex: typeIndex)
            return
        case .endOfFunction:
            try self.endOfFunction(runtime: runtime)
            return
        case .i32Load(let memarg):
            try self.i32Load(runtime: runtime, memarg: memarg)
        case .i64Load(let memarg):
            try self.i64Load(runtime: runtime, memarg: memarg)
        case .f32Load(let memarg):
            try self.f32Load(runtime: runtime, memarg: memarg)
        case .f64Load(let memarg):
            try self.f64Load(runtime: runtime, memarg: memarg)
        case .i32Load8S(let memarg):
            try self.i32Load8S(runtime: runtime, memarg: memarg)
        case .i32Load8U(let memarg):
            try self.i32Load8U(runtime: runtime, memarg: memarg)
        case .i32Load16S(let memarg):
            try self.i32Load16S(runtime: runtime, memarg: memarg)
        case .i32Load16U(let memarg):
            try self.i32Load16U(runtime: runtime, memarg: memarg)
        case .i64Load8S(let memarg):
            try self.i64Load8S(runtime: runtime, memarg: memarg)
        case .i64Load8U(let memarg):
            try self.i64Load8U(runtime: runtime, memarg: memarg)
        case .i64Load16S(let memarg):
            try self.i64Load16S(runtime: runtime, memarg: memarg)
        case .i64Load16U(let memarg):
            try self.i64Load16U(runtime: runtime, memarg: memarg)
        case .i64Load32S(let memarg):
            try self.i64Load32S(runtime: runtime, memarg: memarg)
        case .i64Load32U(let memarg):
            try self.i64Load32U(runtime: runtime, memarg: memarg)
        case .i32Store(let memarg):
            try self.i32Store(runtime: runtime, memarg: memarg)
        case .i64Store(let memarg):
            try self.i64Store(runtime: runtime, memarg: memarg)
        case .f32Store(let memarg):
            try self.f32Store(runtime: runtime, memarg: memarg)
        case .f64Store(let memarg):
            try self.f64Store(runtime: runtime, memarg: memarg)
        case .i32Store8(let memarg):
            try self.i32Store8(runtime: runtime, memarg: memarg)
        case .i32Store16(let memarg):
            try self.i32Store16(runtime: runtime, memarg: memarg)
        case .i64Store8(let memarg):
            try self.i64Store8(runtime: runtime, memarg: memarg)
        case .i64Store16(let memarg):
            try self.i64Store16(runtime: runtime, memarg: memarg)
        case .i64Store32(let memarg):
            try self.i64Store32(runtime: runtime, memarg: memarg)
        case .memorySize:
            try self.memorySize(runtime: runtime)
        case .memoryGrow:
            try self.memoryGrow(runtime: runtime)
        case .memoryInit(let dataIndex):
            try self.memoryInit(runtime: runtime, dataIndex: dataIndex)
        case .memoryDataDrop(let dataIndex):
            try self.memoryDataDrop(runtime: runtime, dataIndex: dataIndex)
        case .memoryCopy:
            try self.memoryCopy(runtime: runtime)
        case .memoryFill:
            try self.memoryFill(runtime: runtime)
        case .numericConst(let value):
            try self.numericConst(runtime: runtime, value: value)
        case .numericIntUnary(let intUnary):
            try self.numericIntUnary(runtime: runtime, intUnary: intUnary)
        case .numericFloatUnary(let floatUnary):
            try self.numericFloatUnary(runtime: runtime, floatUnary: floatUnary)
        case .numericBinary(let binary):
            try self.numericBinary(runtime: runtime, binary: binary)
        case .numericIntBinary(let intBinary):
            try self.numericIntBinary(runtime: runtime, intBinary: intBinary)
        case .numericFloatBinary(let floatBinary):
            try self.numericFloatBinary(runtime: runtime, floatBinary: floatBinary)
        case .numericConversion(let conversion):
            try self.numericConversion(runtime: runtime, conversion: conversion)
        case .drop:
            try self.drop(runtime: runtime)
        case .select:
            try self.select(runtime: runtime)
        case .refNull(let referenceType):
            try self.refNull(runtime: runtime, referenceType: referenceType)
        case .refIsNull:
            try self.refIsNull(runtime: runtime)
        case .refFunc(let functionIndex):
            try self.refFunc(runtime: runtime, functionIndex: functionIndex)
        case .tableGet(let tableIndex):
            try self.tableGet(runtime: runtime, tableIndex: tableIndex)
        case .tableSet(let tableIndex):
            try self.tableSet(runtime: runtime, tableIndex: tableIndex)
        case .tableSize(let tableIndex):
            try self.tableSize(runtime: runtime, tableIndex: tableIndex)
        case .tableGrow(let tableIndex):
            try self.tableGrow(runtime: runtime, tableIndex: tableIndex)
        case .tableFill(let tableIndex):
            try self.tableFill(runtime: runtime, tableIndex: tableIndex)
        case .tableCopy(let dest, let src):
            try self.tableCopy(runtime: runtime, dest: dest, src: src)
        case .tableInit(let tableIndex, let elementIndex):
            try self.tableInit(runtime: runtime, tableIndex: tableIndex, elementIndex: elementIndex)
        case .tableElementDrop(let elementIndex):
            try self.tableElementDrop(runtime: runtime, elementIndex: elementIndex)
        case .localGet(let index):
            try self.localGet(runtime: runtime, index: index)
        case .localSet(let index):
            try self.localSet(runtime: runtime, index: index)
        case .localTee(let index):
            try self.localTee(runtime: runtime, index: index)
        case .globalGet(let index):
            try self.globalGet(runtime: runtime, index: index)
        case .globalSet(let index):
            try self.globalSet(runtime: runtime, index: index)
        }
        programCounter += 1
    }
}

extension Instruction {
    var name: String {
        switch self {
        case .unreachable: return "unreachable"
        case .nop: return "nop"
        case .block: return "block"
        case .loop: return "loop"
        case .ifThen: return "ifThen"
        case .ifThenElse: return "ifThenElse"
        case .end: return "end"
        case .`else`: return "`else`"
        case .br: return "br"
        case .brIf: return "brIf"
        case .brTable: return "brTable"
        case .`return`: return "`return`"
        case .call: return "call"
        case .callIndirect: return "callIndirect"
        case .endOfFunction: return "endOfFunction"
        case .i32Load: return "i32Load"
        case .i64Load: return "i64Load"
        case .f32Load: return "f32Load"
        case .f64Load: return "f64Load"
        case .i32Load8S: return "i32Load8S"
        case .i32Load8U: return "i32Load8U"
        case .i32Load16S: return "i32Load16S"
        case .i32Load16U: return "i32Load16U"
        case .i64Load8S: return "i64Load8S"
        case .i64Load8U: return "i64Load8U"
        case .i64Load16S: return "i64Load16S"
        case .i64Load16U: return "i64Load16U"
        case .i64Load32S: return "i64Load32S"
        case .i64Load32U: return "i64Load32U"
        case .i32Store: return "i32Store"
        case .i64Store: return "i64Store"
        case .f32Store: return "f32Store"
        case .f64Store: return "f64Store"
        case .i32Store8: return "i32Store8"
        case .i32Store16: return "i32Store16"
        case .i64Store8: return "i64Store8"
        case .i64Store16: return "i64Store16"
        case .i64Store32: return "i64Store32"
        case .memorySize: return "memorySize"
        case .memoryGrow: return "memoryGrow"
        case .memoryInit: return "memoryInit"
        case .memoryDataDrop: return "memoryDataDrop"
        case .memoryCopy: return "memoryCopy"
        case .memoryFill: return "memoryFill"
        case .numericConst: return "numericConst"
        case .numericIntUnary: return "numericIntUnary"
        case .numericFloatUnary: return "numericFloatUnary"
        case .numericBinary: return "numericBinary"
        case .numericIntBinary: return "numericIntBinary"
        case .numericFloatBinary: return "numericFloatBinary"
        case .numericConversion: return "numericConversion"
        case .drop: return "drop"
        case .select: return "select"
        case .refNull: return "refNull"
        case .refIsNull: return "refIsNull"
        case .refFunc: return "refFunc"
        case .tableGet: return "tableGet"
        case .tableSet: return "tableSet"
        case .tableSize: return "tableSize"
        case .tableGrow: return "tableGrow"
        case .tableFill: return "tableFill"
        case .tableCopy: return "tableCopy"
        case .tableInit: return "tableInit"
        case .tableElementDrop: return "tableElementDrop"
        case .localGet: return "localGet"
        case .localSet: return "localSet"
        case .localTee: return "localTee"
        case .globalGet: return "globalGet"
        case .globalSet: return "globalSet"
        }
    }
}
