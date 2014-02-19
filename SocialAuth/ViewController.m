#import "ViewController.h"


#import "WBOAuth.h"


#ifndef kWBSDKDemoAppKey
#define kWBSDKDemoAppKey @"849797138"
#endif

#ifndef kWBSDKDemoAppSecret
#define kWBSDKDemoAppSecret @"dcfec2b60653bc9cdbbd027c7a3e4bbb"
#endif




@implementation ViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    
    
    UIButton* sinaLoginBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    [sinaLoginBtn setTitle: @"Sina OAuth" forState:UIControlStateNormal];
    [sinaLoginBtn addTarget: self action:@selector(startAuthorize) forControlEvents:UIControlEventTouchUpInside];
    sinaLoginBtn.frame = CGRectMake(200, 50, 100, 50);
    
    [self.view addSubview: sinaLoginBtn];
}

-(void) startAuthorize
{
    WBOAuth* wbOAuth = [[WBOAuth alloc] init];
    wbOAuth.appKey = kWBSDKDemoAppKey;
    wbOAuth.appSecret = kWBSDKDemoAppSecret;
    [wbOAuth startAuthorize];
}


@end



