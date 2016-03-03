///
///
protocol SigninChildViewController
{
    var loginFields: LoginFields? { get set }
    
    func backButtonEnabled() -> Bool
}