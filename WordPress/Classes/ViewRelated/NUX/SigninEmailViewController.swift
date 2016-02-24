import UIKit

typealias SigninValidateEmailBlock = (String) -> Void

class SigninEmailViewController : UIViewController
{

    var validateEmailCallback: SigninValidateEmailBlock?


    @IBOutlet var emailTextField:UITextField!
    @IBOutlet var submitButton:UIButton!


    class func controller(callback: SigninValidateEmailBlock) -> SigninEmailViewController {
        let storyboard = UIStoryboard(name: "Signin", bundle: NSBundle.mainBundle())
        let controller = storyboard.instantiateViewControllerWithIdentifier("SigninEmailViewController") as! SigninEmailViewController

        controller.validateEmailCallback = callback

        return controller
    }


    // MARK: - Actions


    @IBAction func handleSubmitTapped(sender: UIButton) {
        if let email = emailTextField.text {
            validateEmailCallback?(email)
        }
    }

}
