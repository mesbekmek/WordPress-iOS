import Foundation
import AFNetworking

/// ExportWebViewController adds support for export content XML download
///
public class ExportWebViewController: WPWebViewController
{
    // MARK: - Properties: must be set by creator
    
    /// The `Blog` whose content to export
    ///
    public var blog: Blog? {
        didSet {
            if let blog = blog {
                authToken = blog.authToken
                username = blog.usernameForSite
                password = blog.password
                wpLoginURL = NSURL(string: blog.loginUrl())
                url = NSURL(string: blog.adminUrlWithPath(Export.embedPath))
            }
        }
    }
    
    // MARK: - Navigation constants

    struct Export {
        static let embedPath = "export.php?iframe=true"
        
        static let downloadPath = "/wp-admin/export.php"
        static func downloadQuery() -> NSURLQueryItem {
            return NSURLQueryItem(name: "download", value: "true")
        }
        
        static let dataFile = "export.xml"
    }
    
    // MARK: - Initializer
    
    /// Preferred initializer for ExportWebViewController
    ///
    /// - Parameters:
    ///     - blog: The `Blog` whose content to export
    ///
    public convenience init(blog: Blog) {
        self.init(nibName: "WPWebViewController", bundle: nil)
        
        defer {
            self.secureInteraction = true
            self.blog = blog
        }
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.titleView = nil
        title = NSLocalizedString("Export Content", comment: "Title of Export Content controller")
    }

    // MARK: - UIWebViewDelegate

    override public func webView(webView: UIWebView, shouldStartLoadWithRequest request: NSURLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        
        if let url = request.URL,
           let components = NSURLComponents(URL: url, resolvingAgainstBaseURL: false) where components.path == Export.downloadPath,
           let queryItems = components.queryItems where queryItems.contains(Export.downloadQuery()) {
            
            // TODO: Save to selected location
            
            return false
        }

        return super.webView(webView, shouldStartLoadWithRequest: request, navigationType: navigationType)
    }

}
