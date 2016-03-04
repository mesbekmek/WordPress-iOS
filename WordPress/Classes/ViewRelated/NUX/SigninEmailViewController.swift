import UIKit

typealias SigninValidateEmailBlock = (String) -> Void

class SigninEmailViewController : UIViewController, UITextFieldDelegate
{
    var emailValidationSuccessCallback: SigninValidateEmailBlock?
    var emailValidationFailureCallback: SigninValidateEmailBlock?

    @IBOutlet var emailTextField: UITextField!
    @IBOutlet var submitButton: WPNUXMainButton!

    let accountServiceRemote = AccountServiceRemoteREST()

    class func controller(success: SigninValidateEmailBlock, failure: SigninValidateEmailBlock) -> SigninEmailViewController {
        let storyboard = UIStoryboard(name: "Signin", bundle: NSBundle.mainBundle())
        let controller = storyboard.instantiateViewControllerWithIdentifier("SigninEmailViewController") as! SigninEmailViewController

        controller.emailValidationSuccessCallback = success
        controller.emailValidationFailureCallback = failure
        
        return controller
    }

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        emailTextField.becomeFirstResponder()
    }
    // MARK: - Actions
    
    @IBAction func handleSubmitTapped() {
        if let email = emailTextField.text  {
            checkEmailAddress(email)
        }
    }

    // MARK: -

    func checkEmailAddress(email: String) {
        // TODO: Need some basic validation

        setLoading(true)
        
        let service = AccountService(managedObjectContext: ContextManager.sharedInstance().mainContext)
        service.findExistingAccountByEmail(email,
            success: { [weak self] in
                self?.emailValidationSuccessCallback?(email)
                self?.setLoading(false)
            }, failure: { [weak self] (error: NSError!) in
                DDLogSwift.logError(error.localizedDescription)
                self?.emailValidationFailureCallback?(email)
                self?.setLoading(false)                
        })
    }
    
    private func setLoading(loading: Bool) {
        emailTextField.enabled = !loading
        submitButton.enabled = !loading
        submitButton.showActivityIndicator(loading)
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
