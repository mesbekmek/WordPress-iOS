import UIKit

typealias SigninCallbackBlock = () -> Void

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

        showSigninEmailViewController()
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return .LightContent
    }


    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let child = segue.destinationViewController
        child.view.translatesAutoresizingMaskIntoConstraints = false
    }


    // MARK: - Instance Methods

    func presentChildViewController(controller: UIViewController) {
        let oldChildViewController = childViewControllers.first
        oldChildViewController?.willMoveToParentViewController(nil)

        addChildViewController(controller)
        containerView.addSubview(controller.view)
        controller.view.translatesAutoresizingMaskIntoConstraints = false
        containerView.pinSubviewToAllEdges(controller.view)

        if oldChildViewController == nil {
            controller.didMoveToParentViewController(self)
            return
        }
        controller.view.alpha = 0
        controller.view.layoutIfNeeded()

        UIView.animateWithDuration(0.5,
            animations: {
                controller.view.alpha = 1
                oldChildViewController?.view.alpha = 0
            },
            completion: { finished in
                oldChildViewController?.view.removeFromSuperview()
                oldChildViewController?.removeFromParentViewController()
                controller.didMoveToParentViewController(self)
        })

    }


    // MARK: - Controller Factories


    func showSigninEmailViewController() {
        let controller = SigninEmailViewController.controller({ email in
            self.validateEmail(email)
        })

        presentChildViewController(controller)
    }


    func showSigninMagicLinkViewController() {
        let controller = SigninMagicLinkViewController.controller({
                self.requestLink()
            },
            signinWithPasswordBlock: {
                self.signinWithPassword()
        })

        presentChildViewController(controller)
    }


    func showOpenMailViewController() {
        let controller = SigninOpenMailViewController.controller({
                self.openMail()
            },
            skipBlock: {
                self.signinWithPassword()
        })

        presentChildViewController(controller)
    }


    // MARK: - Child Controller Callbacks


    func validateEmail(email: String) {
        showSigninMagicLinkViewController()
    }


    func signinWithPassword() {
        NSLog("Show password form")
    }


    func requestLink() {
        showOpenMailViewController()
    }


    func openMail() {
        let url = NSURL(string: "message://")!
        if UIApplication.sharedApplication().canOpenURL(url) {
            UIApplication.sharedApplication().openURL(url)
        }
    }


    // MARK: - Actions

    @IBAction func handleCreateAccountTapped(sender: UIButton) {

    }


    @IBAction func handleToggleSigninTapped(sender: UIButton) {

    }


    @IBAction func handleHelpTapped(sender: UIButton) {

    }

}
