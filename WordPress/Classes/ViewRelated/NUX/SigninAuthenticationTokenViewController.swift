import UIKit

class SigninAuthenticationTokenViewController: UIViewController
{

    @IBOutlet var activityIndicator: UIActivityIndicatorView!
    @IBOutlet var label: UILabel!


    var email: String?
    var token: String?
    var authSuccessCallback: SigninCallbackBlock?
    var authFailedCallback: SigninCallbackBlock?


    class func controller(email: String, token: String, successCallback: SigninCallbackBlock, failureCallback: SigninCallbackBlock) -> SigninAuthenticationTokenViewController {
        let storyboard = UIStoryboard(name: "Signin", bundle: NSBundle.mainBundle())
        let controller = storyboard.instantiateViewControllerWithIdentifier("SigninAuthenticationTokenViewController") as! SigninAuthenticationTokenViewController

        controller.authSuccessCallback = successCallback
        controller.authFailedCallback = failureCallback
        controller.token = token
        controller.email = email

        return controller
    }


    override func viewDidLoad() {
        super.viewDidLoad()

        performAuth()
    }


    func performAuth() {
        guard let token = token, email = email else {
            return
        }

        label.text = "Signing in as \(email)"

        activityIndicator.startAnimating()
return
        let authClient = WordPressComOAuthClient()
        authClient.authenticateWithUsername(email,
            password: token,
            multifactorCode: nil,
            success: { [weak self] (authToken: String!) in
                self?.didReceiveOAuthToken(authToken)
            },
            failure: { [weak self] (error: NSError!) in
                DDLogSwift.logError(error.description)
                self?.failedToReceiveOAuthToken()
            })
    }


    func didReceiveOAuthToken(oauthToken: String) {
        let service = AccountService(managedObjectContext: ContextManager.sharedInstance().mainContext)
        let account = service.createOrUpdateAccountWithUsername(email!, authToken: oauthToken)

        service.updateUserDetailsForAccount(account,
            success: { [weak self] in
                // Finally done
                self?.authSuccessCallback?()
            },
            failure: { (error: NSError!) in
                // TODO:
        })
    }


    func failedToReceiveOAuthToken() {

    }


}