import UIKit

class SigninEmailViewController : UIViewController
{

    @IBOutlet var emailTextField:UITextField!
    @IBOutlet var submitButton:UIButton!


    class func controller() -> SigninEmailViewController {
        let storyboard = UIStoryboard(name: "Signin", bundle: NSBundle.mainBundle())
        let controller = storyboard.instantiateViewControllerWithIdentifier("SigninEmailViewController") as! SigninEmailViewController

        return controller
    }


    @IBAction func handleSubmitTapped(sender: UIButton) {
        NSLog("Tapped")
    }

}
