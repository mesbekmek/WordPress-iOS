import UIKit


class SigninViewController : UIViewController
{

    @IBOutlet var containerView: UIView!
    @IBOutlet var helpButton: UIButton!
    @IBOutlet var icon: UIImageView!
    @IBOutlet var toggleSigninButton: UIButton!
    @IBOutlet var createAccountButton: UIButton!


    class func controller() -> SigninViewController {
        let storyboard = UIStoryboard(name: "Signin", bundle: NSBundle.mainBundle())
        let controller = storyboard.instantiateViewControllerWithIdentifier("SigninViewController") as! SigninViewController

        return controller
    }


    override func viewDidLoad() {
        super.viewDidLoad();
        navigationController?.navigationBarHidden = true
    }

}
