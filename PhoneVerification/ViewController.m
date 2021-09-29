//
//  ViewController.m
//  PhoneVerification
//
//  Created by HT-Admin on 27/09/19.
//  Copyright © 2019 HT-Admin. All rights reserved.
//

#import "ViewController.h"
#import "VerifyOtpVC.h"
#import "ConnectionManager.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.tfEnterNum.delegate = self;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard)];

    [self.view addGestureRecognizer:tap];
}


-(void)dismissKeyboard {
    [self.tfEnterNum resignFirstResponder];
}

- (IBAction)continueBtnClicked:(UIButton *)sender {
    
    if (self.tfEnterNum.text.length == 10 ) {
        [self generateOtp];
        
        VerifyOtpVC *secondVC = [[VerifyOtpVC alloc]initWithNibName:@"VerifyOtpVC" bundle:nil];
        [self presentViewController:secondVC animated:YES completion:nil];
              
    }else {
        [ConnectionManager alertWithToastAndDuration:@"Please Enter Complete Phone Number"];
    }
    
}

-(void)generateOtp {
    // Create the URLSession on the default configuration
    NSURLSessionConfiguration *defaultSessionConfiguration = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *defaultSession = [NSURLSession sessionWithConfiguration:defaultSessionConfiguration];

    // Setup the request with URL
    NSURL *url = [NSURL URLWithString:@"Url to send OTP to the mobile number entered"];
    NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:url];

    // Convert POST string parameters to data using UTF8 Encoding
    NSString *postParams = [NSString stringWithFormat:@"userid=%@",self.tfEnterNum.text] ;
    NSData *postData = [postParams dataUsingEncoding:NSUTF8StringEncoding];

    // Convert POST string parameters to data using UTF8 Encoding
    [urlRequest setHTTPMethod:@"POST"];
    [urlRequest setHTTPBody:postData];

    // Create dataTask
    NSURLSessionDataTask *dataTask = [defaultSession dataTaskWithRequest:urlRequest completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        // Handle your response here
        
   NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *) response;
        NSLog(@"%@", httpResponse);
        
        if (error==nil) {
    NSString *strr = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            NSLog(@"Response Data=============%@",strr);
            
     [[NSUserDefaults standardUserDefaults] setObject:self.tfEnterNum.text forKey:@"userId"];
     [[NSUserDefaults standardUserDefaults] synchronize];
      
        }
    }];

    // Fire the request
    [dataTask resume];
}

- (BOOL)textField:(UITextField *)textField
shouldChangeCharactersInRange:(NSRange)range
            replacementString:(NSString *)string {
    
    NSString *resultText = [textField.text stringByReplacingCharactersInRange:range
                         withString:string];
    
    return resultText.length <= 10;
}
@end
