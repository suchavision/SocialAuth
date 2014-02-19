#import "WBAuthViewController.h"
#import "WBOAuth.h"

@implementation WBAuthViewController
{
    UIActivityIndicatorView *indicatorView;
    UIView* headerView ;
}

@synthesize webView;
@synthesize url;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.view.backgroundColor = [UIColor whiteColor];
        CGSize screenSize = [WBAuthViewController getScreenBoundsByOrientation].size;
        CGFloat headerHeight = 80;
        
        // header view
        headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screenSize.width, headerHeight)];
        
        // cancel button
        UIButton* cancelButton = [UIButton buttonWithType: UIButtonTypeSystem];
        [cancelButton setTitle: @"取消" forState:UIControlStateNormal];
        cancelButton.frame = CGRectMake(0, 0, 100, headerHeight);
        [cancelButton addTarget: self action:@selector(cancelOAuth) forControlEvents:UIControlEventTouchUpInside];
        [headerView addSubview: cancelButton];
        
        // title label
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, headerHeight)];
        titleLabel.center = CGPointMake(screenSize.width/2, headerHeight/2);
        titleLabel.text = @"新浪微博登录认证";
        titleLabel.backgroundColor = [UIColor clearColor];
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.textColor = [UIColor whiteColor];
        titleLabel.font = [UIFont boldSystemFontOfSize:20];
        titleLabel.shadowColor = [UIColor grayColor];
        titleLabel.shadowOffset = CGSizeMake(-1, -1);
        [headerView addSubview:titleLabel];
        
        [self.view addSubview: headerView];
        
        // web view
        webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, headerHeight, screenSize.width, screenSize.height - headerHeight)];
        webView.delegate = self;
        [self.view addSubview:webView];
        
        // indicator view
        indicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        [indicatorView setCenter:(CGPoint){self.view.bounds.size.width/2, self.view.bounds.size.height/2}];
        [self.view addSubview:indicatorView];
        
    }
    return self;
}

- (void) cancelOAuth {
    [self dismissViewControllerAnimated:YES completion: nil];
}

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    NSURLRequest *request =[NSURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:60.0];
    [webView loadRequest:request];
}

#pragma mark - UIViewController Rotation

//**************Rotate Needed Begin

// for ios5.0 , 6.0 deprecated
-(BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return YES;
}

-(NSUInteger) supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskAll;
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation {
    return [[[UIApplication sharedApplication] keyWindow] rootViewController].interfaceOrientation ;
}

// for ios6.0 supported
-(BOOL) shouldAutorotate {
    return YES;
}

-(void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
    webView.frame = CGRectMake(0, webView.frame.origin.y, webView.frame.size.width, webView.frame.size.height);
}
//**************Rotate Needed End


#pragma mark - UIWebViewDelegate Methods

- (void)webViewDidStartLoad:(UIWebView *)aWebView
{
	[indicatorView startAnimating];
}

- (void)webViewDidFinishLoad:(UIWebView *)aWebView
{
	[indicatorView stopAnimating];
}

- (void)webView:(UIWebView *)aWebView didFailLoadWithError:(NSError *)error
{
    [indicatorView stopAnimating];
}

- (BOOL)webView:(UIWebView *)aWebView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    NSLog(@"URL : %@",request.URL.absoluteString);
    NSRange range = [request.URL.absoluteString rangeOfString:@"code="];
    
    if (range.location != NSNotFound) {
        
        NSString *code = [request.URL.absoluteString substringFromIndex:range.location + range.length];
        NSLog(@"Code : %@", code);
        if (self.didGetAuthorizeCodeBlock) self.didGetAuthorizeCodeBlock(code);
    }
    
    return YES;
}




#pragma mark - Util Methods

+(CGRect) getScreenBoundsByOrientation
{
    CGRect screenSize = [UIScreen mainScreen].bounds;
    float screenWidth = screenSize.size.width;
    float screenHeight = screenSize.size.height;
    
    UIInterfaceOrientation orientation = [[[UIApplication sharedApplication] keyWindow] rootViewController].interfaceOrientation;
    return UIInterfaceOrientationIsPortrait(orientation) ? (CGRect){{0,0},{screenWidth,screenHeight}} : (CGRect){{0,0},{screenHeight,screenWidth}};
}

@end
