import UIKit
import WordPressShared

/// DomainsViewController handles manipulation and purchasing of a site's domains
///
public class DomainsViewController: UITableViewController
{
    // MARK: - Properties: must be set by creator
    
    /// The blog to manage domains of
    ///
    var blog: Blog!
    
    // MARK: - Initializer

    /// Preferred initializer for DomainsViewController
    ///
    /// - Parameters:
    ///     - blog: The Blog to manage domains of
    ///
    public convenience init(blog: Blog) {
        self.init(style: .Grouped)
        self.blog = blog
    }
    
    // MARK: - View Lifecycle

    override public func viewDidLoad() {
        super.viewDidLoad()
        
        title = NSLocalizedString("Domains", comment: "Title of blog domain management page")
        
        WPStyleGuide.resetReadableMarginsForTableView(tableView)
        WPStyleGuide.configureColorsForView(view, andTableView: tableView)
    }
    
    // MARK: Table View Data Source
    
    override public func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 0
    }
    
    override public func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    override public func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        return UITableViewCell()
    }

    // MARK: - Table View Delegate
    
    override public func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    }

    override public func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return nil
    }

    override public func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return CGFloat.min
    }

    // MARK: - Actions

}
