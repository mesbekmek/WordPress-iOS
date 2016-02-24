import UIKit

class SigninMagicLinkViewController: UIViewController
{

    @IBOutlet var requestLinkButton: UIButton!
    @IBOutlet var usePasswordButton: UIButton!


    var requestLinkCallback: SigninCallbackBlock?
    var signinWithPasswordCallback: SigninCallbackBlock?


    class func controller(requestLinkBlock: SigninCallbackBlock, signinWithPasswordBlock: SigninCallbackBlock) -> SigninMagicLinkViewController {
        let storyboard = UIStoryboard(name: "Signin", bundle: NSBundle.mainBundle())
        let controller = storyboard.instantiateViewControllerWithIdentifier("SigninMagicLinkViewController") as! SigninMagicLinkViewController

        controller.requestLinkCallback = requestLinkBlock
        controller.signinWithPasswordCallback = signinWithPasswordBlock

        return controller
    }


    // MARK: - Actions


    @IBAction func handleRequestLinkTapped(sender: UIButton) {
        requestLinkCallback?()
    }


    @IBAction func handleUsePasswordTapped(sender: UIButton) {
        signinWithPasswordCallback?()
    }

}
