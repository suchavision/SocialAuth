#import "WBRequest.h"

#import "WBUtil.h"
#import "WBEncode.h"

#define kWBRequestTimeOutInterval   180.0
#define kWBRequestStringBoundary    @"293iosfksdfkiowjksdf31jsiuwq003s02dsaffafass3qw"


@implementation WBRequest
{
    NSURLConnection     *connection;
    NSMutableData       *responseData;
}

@synthesize url;
@synthesize httpMethod;
@synthesize params;
@synthesize httpHeaderFields;
@synthesize delegate;


#pragma mark - WBRequest Public Methods

+ (WBRequest *)requestWithURL:(NSString *)url 
                   httpMethod:(NSString *)httpMethod 
                       params:(NSDictionary *)params
             httpHeaderFields:(NSDictionary *)httpHeaderFields
                     delegate:(id<WBRequestDelegate>)delegate
{
    WBRequest *request = [[WBRequest alloc] init];
    
    request.url = url;
    request.httpMethod = httpMethod;
    request.params = params;
    request.httpHeaderFields = httpHeaderFields;
    request.delegate = delegate;
    
    return request;
}


#pragma mark - Public Methods

- (void)connect
{
    NSString *urlString = [WBUtil serializeURL:url params:params httpMethod:httpMethod];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlString]
														   cachePolicy:NSURLRequestReloadIgnoringLocalCacheData
													   timeoutInterval:kWBRequestTimeOutInterval];
    
    [request setHTTPMethod:httpMethod];
    
    if ([httpMethod isEqualToString:@"POST"]) {
        NSMutableData *body = [NSMutableData data];
        [body appendData:[[WBUtil queryStringFromDictionary:params] dataUsingEncoding:NSUTF8StringEncoding]];
        [request setHTTPBody: body];
    }
    
    for (NSString *key in [httpHeaderFields keyEnumerator]) {
        [request setValue:[httpHeaderFields objectForKey:key] forHTTPHeaderField:key];
    }
    
    connection = [[NSURLConnection alloc] initWithRequest:request delegate:self startImmediately:YES];
}

- (void)disconnect
{
	responseData = nil;
    [connection cancel];
    connection = nil;
}



#pragma mark - NSURLConnection Delegate Methods

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
	responseData = [[NSMutableData alloc] init];
	
	if (delegate && [delegate respondsToSelector:@selector(wbRequest:didReceiveResponse:)]){
		[delegate wbRequest:self didReceiveResponse:response];
	}
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
	[responseData appendData:data];
    
    if (delegate && [delegate respondsToSelector:@selector(wbRequest:didReceiveRawData:)]) {
        [delegate wbRequest:self didReceiveRawData: responseData];
    }
}

- (NSCachedURLResponse *)connection:(NSURLConnection *)connection willCacheResponse:(NSCachedURLResponse*)cachedResponse
{
	return nil;
}

- (void)connectionDidFinishLoading:(NSURLConnection *)theConnection 
{
    NSError* error = nil;
    id result = [NSJSONSerialization JSONObjectWithData: responseData options:NSJSONReadingAllowFragments error:&error];
    if (error) {
        if (delegate && [delegate respondsToSelector:@selector(wbRequest:didFailWithError:)]) {
            [delegate wbRequest: self didFailWithError:error];
        }
    }
    else
    if (delegate && [delegate respondsToSelector: @selector(wbRequest:didFinishLoadingWithResult:)]) {
        if (delegate && [delegate respondsToSelector: @selector(wbRequest:didFinishLoadingWithResult:)]) {
            [delegate wbRequest: self didFinishLoadingWithResult: result];
        }
    }
	
    [self disconnect];
}

- (void)connection:(NSURLConnection *)theConnection didFailWithError:(NSError *)error
{
    if (delegate && [delegate respondsToSelector:@selector(wbRequest:didFailWithError:)]) {
        [delegate wbRequest: self didFailWithError:error];
    }
	
    [self disconnect];
}

@end
