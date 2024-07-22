import Testing

@Suite
struct SwiftTests {
    @Test
    func サンプル() {
        #expect(3 == 1 + 2)
    }
}
