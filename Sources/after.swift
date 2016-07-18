import Dispatch
import Foundation.NSDate

/**
 ```
 after(1).then {
     //…
 }
 ```

 - Returns: A new promise that resolves after the specified duration.
 - Parameter duration: The duration in seconds to wait before this promise is resolve.
*/
public func after(_ delay: TimeInterval) -> Promise<Void> {
    return Promise { fulfill, _ in
        DispatchQueue.global(attributes: DispatchQueue.GlobalAttributes(rawValue: UInt64(0))).after(when: .now() + delay, execute: fulfill)
    }
}
