//
//  jsonResponseForUrl.m
//  IPCA
//
//  Created by Vineal on 03/05/18.
//
//

#import "ConnectionManager.h"


@implementation ConnectionManager

+(void)getResponseDataFromURL:(NSString *)url:(NSDictionary*)params withCompletionBlock:(void (^)(NSData *data,NSError *error,NSURLResponse *response))completionBlock andFailBlock:(void (^)(NSString *message,NSURLResponse *response))failBlock
{
   
        
        NSDictionary *jsonBodyDict = params ;
        
        NSData *jsonBodyData = [NSJSONSerialization dataWithJSONObject:jsonBodyDict options:kNilOptions error:nil];
        
        NSMutableURLRequest *request = [NSMutableURLRequest new];
        request.HTTPMethod = @"POST";
        
        [request setURL:[NSURL URLWithString:url]];
        
        [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
        [request setHTTPBody:jsonBodyData];
        
        NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
        
        NSURLSession *session = [NSURLSession sessionWithConfiguration:config
                                                              delegate:nil
                                                         delegateQueue:[NSOperationQueue mainQueue]];
        
  NSURLSessionDataTask *task = [session dataTaskWithRequest:request
                                                completionHandler:^(NSData *data, NSURLResponse *response, NSError *error)
        {
            
if(error)
{
NSLog(@"error=%@",error.localizedDescription);
                                                        
failBlock(error.localizedDescription,response);
}
  else {
      
completionBlock(data,error,response);
  }
 }];
        
        [task resume];
    
}




+ (UIViewController *)getTopViewController {
    UIViewController *topViewController = [[[[UIApplication sharedApplication] delegate] window] rootViewController];
    while (topViewController.presentedViewController) topViewController = topViewController.presentedViewController;
    
    return topViewController;
}

+(void)alertWithToastAndDuration:(NSString*)title
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title
                                                                   message:nil
                                                            preferredStyle:UIAlertControllerStyleAlert];
    
    
    [ConnectionManager.getTopViewController presentViewController:alert animated:YES completion:nil];
    
    // duration in seconds
    int duration = 2;
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, duration * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        [alert dismissViewControllerAnimated:YES completion:nil];
    });
}

@end
