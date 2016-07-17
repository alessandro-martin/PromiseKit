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
        let delta = delay * TimeInterval(NSEC_PER_SEC)
        let when = DispatchTime.now() + Double(Int64(delta)) / Double(NSEC_PER_SEC)
        DispatchQueue.global(attributes: DispatchQueue.GlobalAttributes(rawValue: UInt64(0))).after(when: when, execute: fulfill)
    }
}
