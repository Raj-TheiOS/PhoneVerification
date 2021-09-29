//
//  AwsVerifyVC.m
//  PhoneVerification
//
//  Created by HT-Admin on 02/10/19.
//  Copyright © 2019 HT-Admin. All rights reserved.
//

#import "AwsVerifyVC.h"

@interface AwsVerifyVC ()
@end
@implementation AwsVerifyVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
     self.indicatorView.hidden = YES;
     self.lblStatus.hidden = YES;
     self.btnExit.hidden = YES;
     counter = 0 ;
}

- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result {
   ///your stuff here
    NSString *device_uuid = [[NSUserDefaults standardUserDefaults]
    stringForKey:@"device_uuid"];
    NSLog(@"Device_uuid savedValue :- %@",device_uuid);
    [self dismissViewControllerAnimated:YES completion:nil];
    self.indicatorView.hidden = NO;
    self.lblStatus.hidden = NO;
    self.indicatorView.transform = CGAffineTransformMakeScale(2.5, 2.5);
    [self.indicatorView startAnimating];
    [self verifyingWithAWS];
}

- (IBAction)verifyNumBtnClicked:(UIButton *)sender {
    NSString *uuid = [[NSUUID UUID] UUIDString];
       NSString *message = [NSString stringWithFormat:@"device_uuid:%@",uuid];
       
       [[NSUserDefaults standardUserDefaults] setObject:uuid forKey:@"device_uuid"];
       [[NSUserDefaults standardUserDefaults] synchronize];

       if ([MFMessageComposeViewController canSendText]) {
           MFMessageComposeViewController *messageComposer =
           [[MFMessageComposeViewController alloc] init];
           
           [messageComposer setBody:message];
           messageComposer.recipients = [NSArray arrayWithObjects:
                                           @"8108030843", nil];
           messageComposer.messageComposeDelegate = self;
           [self presentViewController:messageComposer animated:YES completion:nil];
       }
}

- (void)verifyingWithAWS {
    NSString *device_uuid = [[NSUserDefaults standardUserDefaults]
                             stringForKey:@"device_uuid"];
    NSMutableDictionary *jsonBodyDict =[[NSMutableDictionary alloc] initWithDictionary:@{@"device_uuid": device_uuid }] ;
    
    [ConnectionManager getResponseDataFromURL:@"url to verify phone number with aws" :jsonBodyDict withCompletionBlock:^(NSData *data, NSError *error, NSURLResponse *response) {
        
        if (data != nil) {
            NSArray *responseArray = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
            NSLog(@"responseArray = %@",responseArray);
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
            NSLog(@"Response Dictionary =%@",dict);
            
            if ([dict count] > 0) {
                NSDictionary *deviceDict = [dict valueForKey:@"device"];
                NSString *deviceNum = [deviceDict valueForKey:@"origination_number"];
                
                NSString *userId = [[NSUserDefaults standardUserDefaults]
                                    stringForKey:@"userId"];
                NSString *phoneNumber = [NSString stringWithFormat:@"+91%@",userId];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.indicatorView stopAnimating];
                    self.indicatorView.hidden = YES;
                    self.btnExit.hidden = NO;
                    if ([phoneNumber isEqualToString:deviceNum]) {
                        self.lblStatus.text = @"Verification Success";
                    }
                    else{
                        self.lblStatus.text = @"Verification Failed";
                    }
                });
            } else {
                self->counter = self->counter + 1;
                
                NSLog(@"counter :%d",self->counter);
                
                if (self->counter <= 20) {
                    [self verifyingWithAWS];
                } else {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self.indicatorView stopAnimating];
                        self.indicatorView.hidden = YES;
                        self.lblStatus.text = @"Verification Failed";
                        self.btnExit.hidden = NO;
                    });
                }
            }
        } else {
            NSLog(@"No Data");
        }
    }  andFailBlock:^(NSString *message, NSURLResponse *response) {
        // [Utility alertWithRefreshButton:[NSString stringWithFormat:@"%@",message]];
    }];
}


- (IBAction)exitBtnClicked:(UIButton *)sender {
    exit(0);
}

@end
