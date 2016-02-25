import UIKit

typealias SigninSelfHostedSuccessBlock = () -> Void

class SigninSelfHostedViewController: UIViewController {
    var signInSuccessBlock: SigninSelfHostedSuccessBlock?
    
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
        addSiteButton.showActivityIndicator(true)
        
        let loginFields = LoginFields(username: emailField.text, password: passwordField.text, siteUrl: siteURLField.text, multifactorCode: nil, userIsDotCom: false, shouldDisplayMultiFactor: false)
        loginFacade.signInWithLoginFields(loginFields)
    }
    
    private func finishSignIn() {
        // Check if there is an active WordPress.com account. If not, switch tab bar
        // away from Reader to blog list view
        let context = ContextManager.sharedInstance().mainContext
        let accountService = AccountService(managedObjectContext: context)
        let defaultAccount = accountService.defaultWordPressComAccount()
        
        if defaultAccount == nil {
            WPTabBarController.sharedInstance().showMySitesTab()
        }
    }
}

extension SigninSelfHostedViewController: LoginFacadeDelegate {
    // self hosted login finished
    func finishedLoginWithUsername(username: String!, password: String!, xmlrpc: String!, options: [NSObject : AnyObject]!) {
        blogSyncFacade.syncBlogWithUsername(username, password: password, xmlrpc: xmlrpc, options: options) {
            self.addSiteButton.showActivityIndicator(true)
            self.finishSignIn()
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
        
    }
    
    
}