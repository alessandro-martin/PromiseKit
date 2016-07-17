import Foundation
import PromiseKit
import XCTest

class Test_NSNotificationCenter_Swift: XCTestCase {
    func test() {
        let ex = expectation(withDescription: "")
        let userInfo: [NSObject: AnyObject] = ["a": 1]

        NotificationCenter.once(PMKTestNotification).then { d -> Void in
            let a = userInfo as NSDictionary
            let b = d as NSDictionary
            XCTAssertTrue(a.isEqual(b))
            ex.fulfill()
        }

        NotificationCenter.default.post(name: Notification.Name(rawValue: PMKTestNotification), object: nil, userInfo: userInfo)

        waitForExpectations(withTimeout: 1, handler: nil)
    }
}

private let PMKTestNotification = "PMKTestNotification"
