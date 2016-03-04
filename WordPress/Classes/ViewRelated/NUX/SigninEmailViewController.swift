import UIKit

typealias SigninValidateEmailBlock = (String) -> Void

class SigninEmailViewController : UIViewController, UITextFieldDelegate
{
    var emailValidationSuccessCallback: SigninValidateEmailBlock?
    var emailValidationFailureCallback: SigninValidateEmailBlock?

    @IBOutlet var emailTextField:UITextField!
    @IBOutlet var submitButton:UIButton!

    let accountServiceRemote = AccountServiceRemoteREST()

    class func controller(success: SigninValidateEmailBlock, failure: SigninValidateEmailBlock) -> SigninEmailViewController {
        let storyboard = UIStoryboard(name: "Signin", bundle: NSBundle.mainBundle())
        let controller = storyboard.instantiateViewControllerWithIdentifier("SigninEmailViewController") as! SigninEmailViewController

        controller.emailValidationSuccessCallback = success
        controller.emailValidationFailureCallback = failure
        
        return controller
    }

    // MARK: - Actions
    
    @IBAction func handleSubmitTapped(sender: UIButton) {
        if let email = emailTextField.text  {
            checkEmailAddress(email)
        }
    }

    // MARK: -

    func checkEmailAddress(email: String) {
        // TODO: Need some basic validation

        emailTextField.enabled = false

        // TODO: Need to show a busy spinner while doing hte look up.
        let service = AccountService(managedObjectContext: ContextManager.sharedInstance().mainContext)
        service.findExistingAccountByEmail(email,
            success: { [weak self] in
                self?.emailValidationSuccessCallback?(email)
            }, failure: { [weak self] (error: NSError!) in
                DDLogSwift.logError(error.localizedDescription)
                self?.emailTextField.enabled = true
                self?.emailValidationFailureCallback?(email)
        })
    }
}

extension SigninEmailViewController : SigninChildViewController {
    var backButtonEnabled: Bool {
        return true
    }
    
    var loginFields: LoginFields? {
        get {
            return LoginFields(username: emailTextField.text, password: nil, siteUrl: nil, multifactorCode: nil, userIsDotCom: true, shouldDisplayMultiFactor: false)
        }
        set {}
    }
}
