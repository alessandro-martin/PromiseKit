import Foundation
import PromiseKit
import XCTest

class Test_NSObject_Swift: XCTestCase {
    func testKVO() {
        let ex = expectation(withDescription: "")

        let foo = Foo()
        foo.observe("bar").then { (newValue: String) -> Void in
            XCTAssertEqual(newValue, "moo")
            ex.fulfill()
        }.error { err in
            XCTFail()
        }
        foo.bar = "moo"

        waitForExpectations(withTimeout: 1, handler: nil)
    }

    func testAfterlife() {
        let ex = expectation(withDescription: "")
        var killme: NSObject!

        autoreleasepool {

            func innerScope() {
                killme = NSObject()
                after(life: killme).then { _ -> Void in
                    //…
                    ex.fulfill()
                }
            }

            innerScope()

            after(0.2).then {
                killme = nil
            }
        }

        waitForExpectations(withTimeout: 1, handler: nil)
    }

    func testMultiObserveAfterlife() {
        let ex1 = expectation(withDescription: "")
        let ex2 = expectation(withDescription: "")
        var killme: NSObject!

        autoreleasepool {

            func innerScope() {
                killme = NSObject()
                after(life: killme).then { _ -> Void in
                    ex1.fulfill()
                }
                after(life: killme).then { _ -> Void in
                    ex2.fulfill()
                }
            }

            innerScope()

            after(0.2).then {
                killme = nil
            }
        }

        waitForExpectations(withTimeout: 1, handler: nil)
    }
}

private class Foo: NSObject {
    dynamic var bar: String = "bar"
}
