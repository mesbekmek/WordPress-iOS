import UIKit

class SigninOpenMailViewController: UIViewController
{

    @IBOutlet var openMailButton: UIButton!
    @IBOutlet var skipButton: UIButton!


    var openMailCallback: SigninCallbackBlock?
    var skipCallback: SigninCallbackBlock?


    class func controller(openMailBlock: SigninCallbackBlock, skipBlock: SigninCallbackBlock) -> SigninOpenMailViewController {
        let storyboard = UIStoryboard(name: "Signin", bundle: NSBundle.mainBundle())
        let controller = storyboard.instantiateViewControllerWithIdentifier("SigninOpenMailViewController") as! SigninOpenMailViewController

        controller.openMailCallback = openMailBlock
        controller.skipCallback = skipBlock

        return controller
    }


    // MARK: - Actions


    @IBAction func handleOpenMailTapped(sender: UIButton) {
        openMailCallback?()
    }


    @IBAction func handleSkipTapped(sender: UIButton) {
        skipCallback?()
    }
    
}
