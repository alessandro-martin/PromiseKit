#if os(iOS)
import XCTest
import UIKit

class UIKitTestCase: XCTestCase {

    var rootvc: UIViewController {
        return UIApplication.shared().keyWindow!.rootViewController!
    }

    override func setUp() {
        UIApplication.shared().keyWindow!.rootViewController = UIViewController()
    }

    override func tearDown() {
        UIApplication.shared().keyWindow!.rootViewController = nil
    }
}
#endif

import ObjectiveC

func swizzle(_ foo: AnyClass, _ from: Selector, isClassMethod: Bool = false, @noescape body: () -> Void) {
    let get: (AnyClass?, Selector) -> Method = isClassMethod ? class_getClassMethod : class_getInstanceMethod
    let originalMethod = get(foo, from)
    let swizzledMethod = get(foo, Selector("pmk_\(from)"))

    method_exchangeImplementations(originalMethod, swizzledMethod)
    body()
    method_exchangeImplementations(swizzledMethod, originalMethod)
}
