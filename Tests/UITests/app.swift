import PromiseKit
import Social
import UIKit

@UIApplicationMain
class App: UITableViewController, UIApplicationDelegate {

    var window: UIWindow? = UIWindow(frame: UIScreen.main().bounds)
    let testSuceededSwitch = UISwitch()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject : AnyObject]?) -> Bool {
        window!.rootViewController = self
        window!.backgroundColor = .purple()
        window!.makeKeyAndVisible()
        return true
    }

    override func viewDidLoad() {
        view.addSubview(testSuceededSwitch)
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Row.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.text = Row(indexPath)?.description
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch Row(indexPath)! {
        case .imagePickerCancel:
            let p: Promise<UIImage> = promiseViewController(UIImagePickerController())
            p.error(policy: .allErrors) { error in
                guard (error as! CancellableErrorType).cancelled else { abort() }
                self.testSuceededSwitch.isOn = true
            }
            p.error { error in
                abort()
            }
        case .imagePickerEditImage:
            let picker = UIImagePickerController()
            picker.allowsEditing = true
            _ = promiseViewController(picker).then { (img: UIImage) in
                self.testSuceededSwitch.isOn = true
            }
        case .imagePickerPickImage:
            _ = promiseViewController(UIImagePickerController()).then { (image: UIImage) in
                self.testSuceededSwitch.isOn = true
            }
        case .imagePickerPickData:
            _ = promiseViewController(UIImagePickerController()).then { (data: Data) in
                self.testSuceededSwitch.isOn = true
            }
        case .socialComposeCancel:
            let composer = SLComposeViewController(forServiceType: SLServiceTypeFacebook)
            promiseViewController(composer!).error(policy: .allErrors) { error in
                guard (error as! CancellableErrorType).cancelled else { abort() }
                self.testSuceededSwitch.isOn = true
            }
        }
    }
}

enum Row: Int {
    case imagePickerCancel
    case imagePickerEditImage
    case imagePickerPickImage
    case imagePickerPickData
    case socialComposeCancel

    init?(_ indexPath: IndexPath) {
        guard let row = Row(rawValue: (indexPath as NSIndexPath).row) else {
            return nil
        }
        self = row
    }

    var indexPath: IndexPath {
        return IndexPath(row: rawValue, section: 0)
    }

    var description: String {
        return (rawValue + 1).description
    }

    static var count: Int {
        var x = 0
        while Row(rawValue: x) != nil {
            x += 1
        }
        return x
    }
}
