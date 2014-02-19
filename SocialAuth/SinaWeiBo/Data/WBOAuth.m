#import "WBOAuth.h"
#import "WBUtil.h"
#import "WBRequest.h"
#import "WBAuthViewController.h"


#ifndef kWBSDKDemoRedirectURI
#define kWBSDKDemoRedirectURI @"https://api.weibo.com/oauth2/default.html"
#endif


#define kWBAuthorizeURL     @"https://api.weibo.com/oauth2/authorize"
#define kWBAccessTokenURL   @"https://api.weibo.com/oauth2/access_token"


@interface WBOAuth() <WBRequestDelegate>

@end

@implementation WBOAuth

@synthesize appKey;
@synthesize appSecret;

@synthesize delegate;

#pragma mark - Public Methods

// First , load login view
-(void)startAuthorize
{
    [[NSURLCache sharedURLCache] removeAllCachedResponses];
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                            appKey, @"client_id",
                            @"code", @"response_type",
                            kWBSDKDemoRedirectURI, @"redirect_uri",
                            @"mobile", @"display",
                            nil];
    
    NSString *urlString = [WBUtil serializeURL:kWBAuthorizeURL params:params httpMethod:@"GET"];
    
    WBAuthViewController* authController = [[WBAuthViewController alloc] init];
    authController.url = [NSURL URLWithString:urlString];
    authController.didGetAuthorizeCodeBlock = ^void(NSString* authorizeCode) {
        [self requestAccessTokenWithAuthorizeCode: authorizeCode];
    };
    [[[[UIApplication sharedApplication] keyWindow] rootViewController] presentViewController: authController animated:YES completion:nil];
}

// Second , get the access token
- (void)requestAccessTokenWithAuthorizeCode:(NSString *)code
{
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:appKey, @"client_id",
                            appSecret, @"client_secret",
                            @"authorization_code", @"grant_type",
                            kWBSDKDemoRedirectURI, @"redirect_uri",
                            code, @"code", nil];
    
    WBRequest* request = [WBRequest requestWithURL:kWBAccessTokenURL
                                  httpMethod:@"POST"
                                      params:params
                            httpHeaderFields:nil
                                    delegate:self];
    [request connect];
}




#pragma mark - WBRequestDelegate Methods

- (void)wbRequest:(WBRequest *)request didReceiveResponse:(NSURLResponse *)response{
}

- (void)wbRequest:(WBRequest *)request didReceiveRawData:(NSData *)data{
}

- (void)wbRequest:(WBRequest *)request didFailWithError:(NSError *)error{
    if (delegate && [delegate respondsToSelector: @selector(wbOAuth:didFailWithError:)]) {
        [delegate wbOAuth: self didFailWithError:error];
    }
}

- (void)wbRequest:(WBRequest *)request didFinishLoadingWithResult:(id)result{
    if (delegate && [delegate respondsToSelector: @selector(wbOAuth:didSucceedWithToken:)]) {
        [delegate wbOAuth: self didSucceedWithToken:(NSDictionary *)result];
    }
    
    // result
    /**
     {
     "access_token" = "2.00GhM8WB09DfVvf29ea31f21Gi3hFC";
     "expires_in" = 157679999;
     "remind_in" = 157679999;
     uid = 1395459240;
     }
     **/
}



@end
