import UIKit

class SigninSelfHostedViewController: UIViewController {
    var signInSuccessBlock: SigninSuccessBlock?
    var signInFailureBlock: SigninFailureBlock?
    
    var email: String!
    
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var siteURLField: UITextField!
    @IBOutlet weak var addSiteButton: WPNUXMainButton!
    
    lazy var loginFacade: LoginFacade = {
        let facade = LoginFacade()
        facade.delegate = self
        return facade
    }()
    
    lazy var blogSyncFacade = BlogSyncFacade()
    
    class func controller(email: String, success: SigninSuccessBlock, failure: SigninFailureBlock) -> SigninSelfHostedViewController {
        let storyboard = UIStoryboard(name: "SignInSelfHosted", bundle: NSBundle.mainBundle())
        let controller = storyboard.instantiateViewControllerWithIdentifier("SigninSelfHostedViewController") as! SigninSelfHostedViewController
        
        controller.email = email
        controller.signInSuccessBlock = success
        controller.signInFailureBlock = failure
        
        return controller
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        emailField.text = email
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        dispatch_async(dispatch_get_main_queue()) {
            self.passwordField.becomeFirstResponder()
        }
    }
    
    @IBAction func addSiteTapped() {
        addSiteButton.showActivityIndicator(true)
        
        let loginFields = LoginFields(username: emailField.text, password: passwordField.text, siteUrl: siteURLField.text, multifactorCode: nil, userIsDotCom: false, shouldDisplayMultiFactor: false)
        loginFacade.signInWithLoginFields(loginFields)
    }
}

extension SigninSelfHostedViewController: LoginFacadeDelegate {
    func finishedLoginWithUsername(username: String!, password: String!, xmlrpc: String!, options: [NSObject : AnyObject]!) {
        blogSyncFacade.syncBlogWithUsername(username, password: password, xmlrpc: xmlrpc, options: options) {
            self.addSiteButton.showActivityIndicator(true)
            self.signInSuccessBlock?()
        }
    }
    
    func finishedLoginWithUsername(username: String!, authToken: String!, requiredMultifactorCode: Bool) {
        
    }
    
    func displayLoginMessage(message: String!) {
        
    }
    
    func displayRemoteError(error: NSError!) {
        
    }
    
    func needsMultifactorCode() {
        self.signInFailureBlock?(error: SigninFailureError.NeedsMultifactorCode)
    }
}

extension SigninSelfHostedViewController: UITextFieldDelegate {
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        if textField == emailField {
            passwordField.becomeFirstResponder()
        } else if textField == passwordField {
            siteURLField.becomeFirstResponder()
        } else if textField == siteURLField {
            addSiteTapped()
        }
        
        return true
    }
}

extension SigninSelfHostedViewController: SigninChildViewController {
    var backButtonEnabled: Bool {
        return true
    }
    
    var loginFields: LoginFields? {
        get {
            return LoginFields(username: emailField.text, password: passwordField.text, siteUrl: siteURLField.text, multifactorCode: nil, userIsDotCom: false, shouldDisplayMultiFactor: true)
        }
        set {}
    }
}
