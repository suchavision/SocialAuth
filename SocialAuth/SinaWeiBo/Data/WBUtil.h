#import <Foundation/Foundation.h>

@interface WBUtil : NSObject


+ (NSString *)serializeURL:(NSString *)baseURL params:(NSDictionary *)params httpMethod:(NSString *)httpMethod;

+ (NSString *)queryStringFromDictionary:(NSDictionary *)dict;

@end
