import UIKit

typealias SigninValidateEmailBlock = (String) -> Void

class SigninEmailViewController : UIViewController, UITextFieldDelegate
{
    var emailValidationSuccessCallback: SigninValidateEmailBlock?
    var emailValidationFailureCallback: SigninValidateEmailBlock?

    lazy var onePasswordFacade = OnePasswordFacade()

    @IBOutlet var emailTextField: WPWalkthroughTextField!
    @IBOutlet var submitButton: WPNUXMainButton!

    let accountServiceRemote = AccountServiceRemoteREST()

    class func controller(success: SigninValidateEmailBlock, failure: SigninValidateEmailBlock) -> SigninEmailViewController {
        let storyboard = UIStoryboard(name: "Signin", bundle: NSBundle.mainBundle())
        let controller = storyboard.instantiateViewControllerWithIdentifier("SigninEmailViewController") as! SigninEmailViewController

        controller.emailValidationSuccessCallback = success
        controller.emailValidationFailureCallback = failure
        
        return controller
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        addOnePasswordButton()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        emailTextField.becomeFirstResponder()
    }
    
    private func addOnePasswordButton() {
        let onePasswordButton = UIButton(type: .Custom)
        onePasswordButton.setImage(UIImage(named: "onepassword-wp-button"), forState: .Normal)
        onePasswordButton.addTarget(self, action: "onePasswordButtonTapped", forControlEvents: .TouchUpInside)
        onePasswordButton.sizeToFit()
        
        emailTextField.rightView = onePasswordButton
        emailTextField.rightViewPadding = UIOffset(horizontal: 9.0, vertical: 0.0)
        
        emailTextField.rightViewMode = onePasswordFacade.isOnePasswordEnabled() ? .Always : .Never
    }
    
    // MARK: - Actions
    
    @IBAction func handleSubmitTapped() {
        if let email = emailTextField.text  {
            checkEmailAddress(email)
        }
    }
    
    @IBAction private func onePasswordButtonTapped() {
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
