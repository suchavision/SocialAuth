@interface WBAuthViewController : UIViewController <UIWebViewDelegate>{
	UIWebView *webView;
    NSURL *url;
}

@property (nonatomic, retain) UIWebView *webView;
@property (nonatomic, retain) NSURL *url;

@property (copy) void(^didGetAuthorizeCodeBlock)(NSString* authorizeCode);

@end
