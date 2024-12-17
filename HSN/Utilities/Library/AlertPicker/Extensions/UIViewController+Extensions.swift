import UIKit

extension UIViewController {
    var alertController: UIAlertController? {
        guard let alert = UIApplication.topViewController() as? UIAlertController else { return nil }
        return alert
    }
    func showSimpleAlert(message:String) {
           let alert = UIAlertController(title: kAppName, message: message,preferredStyle: UIAlertController.Style.alert)

           alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: { _ in
               //Cancel Action
           }))
           self.present(alert, animated: true, completion: nil)
       }
       
        static func getStoryboardID()->String
       {
           return String.init(describing: self)
       }
    static func storyboardID()->String
     {
       return String.init(describing: self)
       }
}
