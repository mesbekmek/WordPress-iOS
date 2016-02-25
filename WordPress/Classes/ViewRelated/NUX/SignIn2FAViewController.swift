import UIKit
import WordPressShared

class SignIn2FAViewController: UIViewController {
    
    @IBOutlet weak var sendCodebutton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setSendCodeButtonText()
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
        sendCodebutton.addTarget(self, action: "sendVerificationCode:", forControlEvents: .TouchUpInside)
    }
}