@testable import Parser
import XCTest

final class ByteStreamTests: XCTestCase {
    func testStaticByteStream() {
        var stream = StaticByteStream(bytes: [1, 2])
        XCTAssertThrowsError(try stream.consume(3)) { error in
            guard case let Parser.Error<UInt8>.unexpected(actual, expected: expected) = error else {
                return XCTFail("Unexpected error: \(error)")
            }
            XCTAssertEqual(actual, 1)
            XCTAssertEqual(expected, [3])
            XCTAssertEqual(stream.currentIndex, 0)
        }

        stream = StaticByteStream(bytes: [1, 2])
        XCTAssertEqual(stream.bytes, [1, 2])
        XCTAssertEqual(stream.currentIndex, 0)

        XCTAssertEqual(try stream.peek(), 1)
        XCTAssertEqual(stream.currentIndex, 0)
        XCTAssertEqual(try stream.hasReachedEnd(), false)

        XCTAssertNoThrow(try stream.consume(1))
        XCTAssertEqual(stream.currentIndex, 1)
        XCTAssertEqual(try stream.hasReachedEnd(), false)

        XCTAssertEqual(try stream.peek(), 2)
        XCTAssertEqual(stream.currentIndex, 1)
        XCTAssertEqual(try stream.hasReachedEnd(), false)

        XCTAssertNoThrow(try stream.consume(2))
        XCTAssertEqual(stream.currentIndex, 2)
        XCTAssertEqual(try stream.hasReachedEnd(), true)

        XCTAssertThrowsError(try stream.peek()) { error in
            if case Parser.Error<UInt8>.unexpectedEnd = error {
                XCTAssertEqual(stream.currentIndex, 2)
            } else {
                XCTFail("Unexpected error: \(error)")
            }
        }

        XCTAssertThrowsError(try stream.consume(3)) { error in
            guard case Parser.Error<UInt8>.unexpectedEnd = error else {
                return XCTFail("Unexpected error: \(error)")
            }
            XCTAssertEqual(stream.currentIndex, 2)
        }
    }

    func testStaticByteStream_equatable() {
        let a = StaticByteStream(bytes: [1, 2])
        let b = StaticByteStream(bytes: [1, 2])
        let c = StaticByteStream(bytes: [1, 2])
        let d = StaticByteStream(bytes: [1, 2, 3])

        XCTAssertNoThrow(try c.consume(1))

        XCTAssertEqual(a, b)
        XCTAssertNotEqual(b, c)
        XCTAssertNotEqual(c, d)
    }

    func testString_byteStream() {
        let actual = "Web🌏Assembly".byteStream
        let expected = StaticByteStream(bytes: [
            0x57, 0x65, 0x62, 0xF0, 0x9F, 0x8C, 0x8F, 0x41, 0x73, 0x73, 0x65, 0x6D, 0x62, 0x6C, 0x79,
        ])
        XCTAssertEqual(actual, expected)
    }
}