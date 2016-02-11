import Foundation
import AFNetworking

/// ExportWebViewController adds support for export content XML download
///
public class ExportWebViewController: WPWebViewController, UIDocumentInteractionControllerDelegate
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
            
            let session = AFHTTPSessionManager()
            let downloadTask = session.downloadTaskWithRequest(request,
                progress: nil,
                destination: { file, response in
                    let file = response.suggestedFilename ?? Export.dataFile
                    let path = (NSTemporaryDirectory() as NSString).stringByAppendingPathComponent(file)
                    let url = NSURL(fileURLWithPath: path, isDirectory: false)
                    return url
                },
                completionHandler: { response, filePath, error in
                    guard let file = filePath where error == nil else {
                        print("completionHandler: \(error)")
                        return
                    }

                    let controller = UIDocumentInteractionController(URL: file)
                    controller.delegate = self
                    controller.presentOptionsMenuFromRect(self.view.frame, inView: self.view, animated: true)
                    })
            downloadTask.resume()
            
            return false
        }

        return super.webView(webView, shouldStartLoadWithRequest: request, navigationType: navigationType)
    }

    // MARK: - UIDocumentInteractionControllerDelegate

    public func documentInteractionController(controller: UIDocumentInteractionController, willBeginSendingToApplication application: String?) {
        print("willBeginSendingToApplication: \(application)")
    }

    public func documentInteractionController(controller: UIDocumentInteractionController, didEndSendingToApplication application: String?) {
        print("didEndSendingToApplication: \(application)")
    }

}
