import UIKit

class SigninSelfHostedViewController: UIViewController {
    var email: String!
    
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var siteURLField: UITextField!
    
    class func controller(email: String) -> SigninSelfHostedViewController {
        let storyboard = UIStoryboard(name: "SignInSelfHosted", bundle: NSBundle.mainBundle())
        let controller = storyboard.instantiateViewControllerWithIdentifier("SigninSelfHostedViewController") as! SigninSelfHostedViewController
        
        controller.email = email
        
        return controller
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        emailField.text = email
    }
    
    @IBAction func addSiteTapped() {
    }
}