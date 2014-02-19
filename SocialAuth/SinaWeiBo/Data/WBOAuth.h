
@class WBOAuth;

@protocol WBOAuthDelegate <NSObject>

@optional

-(void) wbOAuth:(WBOAuth *)wbOAuth didFailWithError:(NSError *)error;
-(void) wbOAuth: (WBOAuth*)wbOAuth didSucceedWithToken:(NSDictionary*)results;

@end


@interface WBOAuth : NSObject

@property (strong) NSString* appKey;
@property (strong) NSString* appSecret;

@property (assign) id<WBOAuthDelegate> delegate;

-(void)startAuthorize;


@end
