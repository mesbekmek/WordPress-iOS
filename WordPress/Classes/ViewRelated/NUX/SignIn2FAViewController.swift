import UIKit
import WordPressShared
import SVProgressHUD

class SignIn2FAViewController: UIViewController {
    var signInSuccessBlock: SigninSuccessBlock?
    var signInFailureBlock: SigninFailureBlock?

    @IBOutlet weak var verificationCodeField: UITextField!
    @IBOutlet weak var sendCodebutton: UIButton!
    @IBOutlet weak var verifyButton: WPNUXMainButton!

    private var loginFields: LoginFields!

    lazy private var loginFacade: LoginFacade = {
        let facade = LoginFacade()
        facade.delegate = self
        return facade
    }()
    
    lazy var blogSyncFacade = BlogSyncFacade()
    lazy var accountServiceFacade = AccountServiceFacade()
    
    class func controller(loginFields: LoginFields, success: SigninSuccessBlock?) -> SignIn2FAViewController {
        let storyboard = UIStoryboard(name: "SignInSelfHosted", bundle: NSBundle.mainBundle())
        let controller = storyboard.instantiateViewControllerWithIdentifier("SignIn2FAViewController") as! SignIn2FAViewController
        
        controller.loginFields = loginFields
        controller.signInSuccessBlock = success
        
        return controller
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setSendCodeButtonText()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        verificationCodeField.becomeFirstResponder()
    }
    
    private func setSendCodeButtonText() {
        // Text: Verification Code SMS
        let codeText = NSLocalizedString("Enter the code on your authenticator app or ", comment: "Message displayed when a verification code is needed")
        let attributedCodeText = NSMutableAttributedString(string: codeText)
        
        let smsText = NSLocalizedString("send the code via text message.", comment: "Sends an SMS with the Multifactor Auth Code")
        let attributedSmsText = NSMutableAttributedString(string: smsText)
        attributedSmsText.applyUnderline()
        
        attributedCodeText.appendAttributedString(attributedSmsText)
        attributedCodeText.applyFont(WPNUXUtility.confirmationLabelFont())
        attributedCodeText.applyForegroundColor(UIColor.whiteColor())
        
        let attributedCodeHighlighted = attributedCodeText.mutableCopy() as! NSMutableAttributedString
        attributedCodeHighlighted.applyForegroundColor(WPNUXUtility.confirmationLabelColor())
        
        sendCodebutton.titleLabel!.lineBreakMode = .ByWordWrapping
        sendCodebutton.titleLabel!.textAlignment = .Center
        sendCodebutton.titleLabel!.numberOfLines = 3
        sendCodebutton.setAttributedTitle(attributedCodeText, forState: .Normal)
        sendCodebutton.setAttributedTitle(attributedCodeHighlighted, forState: .Highlighted)
        sendCodebutton.addTarget(self, action: "sendVerificationCode", forControlEvents: .TouchUpInside)
    }
    
    @IBAction private func sendVerificationCode() {
        let message = NSLocalizedString("SMS Sent", comment: "One Time Code has been sent via SMS")
        SVProgressHUD.showSuccessWithStatus(message)
        
        loginFacade.requestOneTimeCodeWithLoginFields(loginFields)
    }
    
    @IBAction func verifyTapped() {
        loginFields.multifactorCode = verificationCodeField.text

        verifyButton.showActivityIndicator(true)
        loginFacade.signInWithLoginFields(loginFields)
    }
}

extension SignIn2FAViewController: LoginFacadeDelegate {
    func finishedLoginWithUsername(username: String!, password: String!, xmlrpc: String!, options: [NSObject : AnyObject]!) {
        // TODO: 'dismiss login message'
        blogSyncFacade.syncBlogWithUsername(username, password: password, xmlrpc: xmlrpc, options: options) {
            self.signInSuccessBlock?()
        }
    }
    
    func finishedLoginWithUsername(username: String!, authToken: String!, requiredMultifactorCode: Bool) {
        // dismiss login message
        // TODO: Handle 'shouldReauthenticateDefaultAccount' (see this method in LoginViewModel)
        
        let failureHandler: ((NSError!) -> Void)! = { [weak self] error in
            // dismiss login message
            // displayRemoteError(error)
            self?.signInFailureBlock?(error: error)
        }
        
        //[self displayLoginMessage:NSLocalizedString(@"Getting account information", nil)];
        
        let account = accountServiceFacade.createOrUpdateWordPressComAccountWithUsername(username, authToken:authToken)
        blogSyncFacade.syncBlogsForAccount(account, success: { [weak self] in
            // once blogs for the accounts are synced, we want to update account details for it
            self?.accountServiceFacade.updateUserDetailsForAccount(account, success: { [weak self] in
                // Dismiss the UI
//                [self dismissLoginMessage];
//                [self finishedLogin];
                self?.signInSuccessBlock?()
                // Hit the Tracker
//                NSDictionary *properties = @{
//                @"multifactor" : @(requiredMultifactorCode),
//                @"dotcom_user" : @(YES)
//                };
//                
//                [WPAnalytics track:WPAnalyticsStatSignedIn withProperties:properties];
//                [WPAnalytics refreshMetadata];

                }, failure: failureHandler)
            }, failure: failureHandler)
    }
//
//    func displayLoginMessage(message: String!) {
//        
//    }
//    
//    func displayRemoteError(error: NSError!) {
//        
//    }
//    
//    func needsMultifactorCode() {
//        
//    }
}
