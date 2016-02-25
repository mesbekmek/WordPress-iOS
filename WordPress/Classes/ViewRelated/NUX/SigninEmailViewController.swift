import UIKit

typealias SigninValidateEmailBlock = (String) -> Void

class SigninEmailViewController : UIViewController, UITextFieldDelegate
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
        if let email = emailTextField.text  {
            validateEmailCallback?(email)
        }
    }


    // MARK: -


    func checkEmailAddress(email: String) {
        emailTextField.enabled = false
        let service = AccountService(managedObjectContext: ContextManager.sharedInstance().mainContext)
        service.findExistingAccountByEmail(email,
            success: { [weak self] in
                self?.didValidateEmail(email)
            }, failure: { [weak self] (error: NSError!) in
                DDLogSwift.logError(error.localizedDescription)
                self?.emailTextField.enabled = true
        })
    }


    func didValidateEmail(email: String) {
        validateEmailCallback?(email)
    }

}
