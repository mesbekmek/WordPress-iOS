import UIKit
import WordPressShared

/// DomainsViewController handles manipulation and purchasing of a site's domains
///
public class DomainsViewController: UITableViewController
{
    // MARK: - Properties: must be set by creator
    
    /// The blog to manage domains of
    ///
    let blog: Blog

    // MARK: - Properties

    private var contents: [SectionContent]!

    // MARK: - Initializer

    /// Designated initializer for DomainsViewController
    ///
    /// - Parameters:
    ///     - blog: The Blog to manage domains of
    ///
    public init(blog: Blog) {
        self.blog = blog
        super.init(style: .Grouped)
    }

    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - View Lifecycle

    override public func viewDidLoad() {
        super.viewDidLoad()
        
        title = NSLocalizedString("Domains", comment: "Title of blog domain management page")
        
        contents = [.AddDomain]
        
        WPStyleGuide.resetReadableMarginsForTableView(tableView)
        WPStyleGuide.configureColorsForView(view, andTableView: tableView)
    }
    
    // MARK: - Table View Data Source
    
    /// Sections in the controller
    ///
    private enum SectionContent
    {
        case AddDomain
        
        var numberOfRows: Int {
            switch self {
            case .AddDomain:
                return AddDomainContent.rows.count
            }
        }

        var title: String {
            switch self {
            case .AddDomain:
                return NSLocalizedString("Add A New Domain", comment: "Section title for 'Add A New Domain' in Domains screen")
            }
        }
        
        func cell(row: Int) -> UITableViewCell {
            switch self {
            case .AddDomain:
                return AddDomainContent.rows[row].cell
            }
        }
    }

    /// Rows in the 'Add A New Domain' section
    ///
    private enum AddDomainContent
    {
        case FindNew
        case ConnectOwn
        
        static let rows: [AddDomainContent] = [.FindNew, .ConnectOwn]
        
        var title: String {
            switch self {
            case .FindNew:
                return NSLocalizedString("Find A New Domain", comment: "Label for 'Find A New Domain' in Domains screen")
            case .ConnectOwn:
                return NSLocalizedString("Or connect your own domain", comment: "Label for 'Connect Your Own Domain' in Domains screen")
            }
        }
        
        var cell: UITableViewCell {
            let cell = WPTableViewCell(style: .Value1, reuseIdentifier: nil)
            cell.textLabel?.text = title
            switch self {
            case .FindNew:
                WPStyleGuide.configureTableViewActionCell(cell)
            case .ConnectOwn:
                WPStyleGuide.configureTableViewCell(cell)
            }

            return cell
        }
    }
    
    override public func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return contents.count
    }
    
    override public func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contents[section].numberOfRows
    }
    
    override public func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        return contents[indexPath.section].cell(indexPath.row)
    }

    // MARK: - Table View Delegate
    
    override public func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        switch contents[indexPath.section] {
        case .AddDomain:
            switch AddDomainContent.rows[indexPath.row] {
            case .FindNew:
                findNewDomain()
            case .ConnectOwn:
                connectOwnDomain()
                break
            }
        }
    }

    override public func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header  = WPTableViewSectionHeaderFooterView(reuseIdentifier: nil, style: .Header)
        header.title = contents[section].title
        
        return header
    }

    override public func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return WPTableViewSectionHeaderFooterView.heightForHeader(contents[section].title, width: tableView.frame.width)
    }

    // MARK: - Actions
    
    private func findNewDomain() {
        // TODO: Implement findNewDomain()
    }

    private func connectOwnDomain() {
        // TODO: Implement connectOwnDomain()
    }
}
