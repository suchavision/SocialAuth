@class WBRequest;

@protocol WBRequestDelegate <NSObject>

@optional

- (void)wbRequest:(WBRequest *)request didReceiveResponse:(NSURLResponse *)response;

- (void)wbRequest:(WBRequest *)request didReceiveRawData:(NSData *)data;

- (void)wbRequest:(WBRequest *)request didFailWithError:(NSError *)error;

- (void)wbRequest:(WBRequest *)request didFinishLoadingWithResult:(id)result;

@end

@interface WBRequest : NSObject

@property (nonatomic, strong) NSString *url;
@property (nonatomic, strong) NSString *httpMethod;
@property (nonatomic, strong) NSDictionary *params;
@property (nonatomic, strong) NSDictionary *httpHeaderFields;
@property (nonatomic, assign) id<WBRequestDelegate> delegate;

+ (WBRequest *)requestWithURL:(NSString *)url 
                   httpMethod:(NSString *)httpMethod 
                       params:(NSDictionary *)params
             httpHeaderFields:(NSDictionary *)httpHeaderFields
                     delegate:(id<WBRequestDelegate>)delegate;


#pragma mark - Public Methods

- (void)connect;
- (void)disconnect;

@end
