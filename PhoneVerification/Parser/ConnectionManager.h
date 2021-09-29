//
//  jsonResponseForUrl.h
//  IPCA
//
//  Created by Vineal on 03/05/18.
//
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface ConnectionManager : NSObject

typedef void (^CompletionPassBlock)(NSData *,NSError *,NSURLResponse *);
typedef void (^FailBlock)(NSString *,NSURLResponse *);

+(void)getResponseDataFromURL:(NSString *)url:(NSDictionary*)params withCompletionBlock:(void (^)(NSData *data,NSError *error,NSURLResponse *response))completionBlock andFailBlock:(void (^)(NSString *message,NSURLResponse *response))failBlock;

+ (UIViewController *)getTopViewController;

+(void)alertWithToastAndDuration:(NSString*)title;

@end
