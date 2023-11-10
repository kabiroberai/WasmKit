let guestPrelude = """
    // DO NOT EDIT.
    //
    // Generated by the wit-overlay-generator

    #if arch(wasm32)
    import WASILibc
    @_implementationOnly import _CabiShims

    fileprivate enum Prelude {
        class LeakBox<Wrapped> {
            let wrapped: Wrapped
            init(wrapped: Wrapped) {
                self.wrapped = wrapped
            }
        }

        static func release(_ buffer: UnsafeMutableRawPointer) {
            buffer.deallocate()
        }

        /// Before calling any exported function, this function must be called to ensure
        /// that the static constructors are called because wasi-libc and Swift runtime
        /// has some ctor works to do.
        static func initializeOnce() {
            enum Static {
                static var _initialized = false
            }
            guard !Static._initialized else { return }
            __wasm_call_ctors()
        }

        static func deallocateList(
            pointer: UInt32, length: UInt32, elementSize: Int,
            deallocateElement: (UnsafeMutableRawPointer) -> Void
        ) {
            guard let basePointer = UnsafeMutableRawPointer(bitPattern: Int(pointer)) else {
                return
            }
            for i in 0..<Int(length) {
                let elementPointer = basePointer.advanced(by: i * elementSize)
                deallocateElement(elementPointer)
            }
            basePointer.deallocate()
        }

        static func deallocateString(pointer: UInt32, length: UInt32) {
            UnsafeMutableRawPointer(bitPattern: Int(pointer))?.deallocate()
        }

        static func liftList<Element>(
            pointer: UInt32, length: UInt32, elementSize: Int,
            loadElement: (UnsafeRawPointer) -> Element
        ) -> [Element] {
            var elements = [Element]()
            elements.reserveCapacity(Int(elementSize))
            let guestPointer = UnsafeRawPointer(bitPattern: Int(pointer))!
            for i in 0..<Int(length) {
                let element = loadElement(guestPointer.advanced(by: i * elementSize))
                elements.append(element)
            }
            return elements
        }

        static func lowerList<Key, Value>(
            _ dictionary: [Key: Value], elementSize: Int, elementAlignment: Int,
            storeElement: ((Key, Value), UnsafeMutableRawPointer) -> Void
        ) -> (pointer: UInt, length: UInt) {
            return lowerList(
                Array(dictionary), elementSize: elementSize,
                elementAlignment: elementAlignment, storeElement: storeElement
            )
        }

        static func lowerList<Element>(
            _ array: [Element], elementSize: Int, elementAlignment: Int,
            storeElement: (Element, UnsafeMutableRawPointer) -> Void
        ) -> (pointer: UInt, length: UInt) {
            let newBuffer = malloc(elementSize * array.count)
            for (i, element) in array.enumerated() {
                storeElement(element, newBuffer!.advanced(by: i * elementSize))
            }
            return (
                newBuffer.map { UInt(bitPattern: $0) } ?? 0, UInt(array.count)
            )
        }

        /// Create a buffer pointer with the given array contents.
        ///
        /// The returned buffer pointer is leaked and not managed by Swift's memory model,
        /// so the caller is responsible for deallocating it after use. It's useful to
        /// dynamically control lifetime of buffer in unstructured way. (e.g. returning
        /// a list/string from an exported function requires a separate cleanup function call
        /// after the caller component reads and copies the content into their memory space,
        /// so callee has to keep the buffer available until the exported cleanup function
        /// is called.)
        static func leakUnderlyingBuffer<Element>(_ array: [Element]) -> UInt {
             precondition(_isPOD(Element.self))
            // TODO: As an optimization, we can reuse the underlying buffer space of `Array`,
            // but the buffer is somehow deallocated even performing unbalanced retain operation.
            // So this function just creates a new buffer and copy the contents of the given array
            // for now.
            //
            // let (owner, pointer): (AnyObject?, UnsafeRawPointer) = _convertConstArrayToPointerArgument(array)
            // Unmanaged.passRetained(owner!)
            // return pointer
            return array.withUnsafeBufferPointer { buffer in
                let rawBuffer = UnsafeRawBufferPointer(buffer)
                let newBuffer = UnsafeMutableRawBufferPointer.allocate(
                    byteCount: rawBuffer.count * MemoryLayout<Element>.size,
                    alignment: MemoryLayout<Element>.alignment
                )
                newBuffer.copyMemory(from: rawBuffer)
                return newBuffer.baseAddress.map { UInt(bitPattern: $0) } ?? 0
            }
        }
    }

    public struct ComponentError<Content>: Error {
        let content: Content

        init(_ content: Content) {
            self.content = content
        }
    }

    extension ComponentError: Equatable where Content: Equatable {}
    extension ComponentError: Hashable where Content: Hashable {}

    // TODO: use `@_expose(wasm)`
    // NOTE: multiple objects in a component can have cabi_realloc definition so use `@_weakLinked` here.
    @_weakLinked
    @_cdecl("cabi_realloc")
    func cabi_realloc(old: UnsafeMutableRawPointer, oldSize: UInt, align: UInt, newSize: UInt) -> UnsafeMutableRawPointer {
        realloc(old, Int(newSize))
    }
    """