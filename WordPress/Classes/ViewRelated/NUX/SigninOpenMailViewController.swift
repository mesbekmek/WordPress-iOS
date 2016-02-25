import UIKit

class SigninOpenMailViewController: UIViewController
{

    @IBOutlet var openMailButton: UIButton!
    @IBOutlet var skipButton: UIButton!

    var email: String?
    var skipCallback: SigninCallbackBlock?


    class func controller(email: String, skipBlock: SigninCallbackBlock) -> SigninOpenMailViewController {
        let storyboard = UIStoryboard(name: "Signin", bundle: NSBundle.mainBundle())
        let controller = storyboard.instantiateViewControllerWithIdentifier("SigninOpenMailViewController") as! SigninOpenMailViewController

        controller.email = email
        controller.skipCallback = skipBlock

        return controller
    }


    // MARK: - Actions


    @IBAction func handleOpenMailTapped(sender: UIButton) {
        let url = NSURL(string: "message://")!
        UIApplication.sharedApplication().openURL(url)
    }


    @IBAction func handleSkipTapped(sender: UIButton) {
        skipCallback?()
    }
    
}
