//
//  VerifyOtpVC.m
//  PhoneVerification
//
//  Created by HT-Admin on 02/10/19.
//  Copyright © 2019 HT-Admin. All rights reserved.
//

#import "VerifyOtpVC.h"
#import "AwsVerifyVC.h"

@interface VerifyOtpVC ()

@end

@implementation VerifyOtpVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self ScreenRefreshAndValidate];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard)];

    [self.view addGestureRecognizer:tap];
}

-(void)dismissKeyboard {
    [self.tfOne resignFirstResponder];
    [self.tfTwo resignFirstResponder];
    [self.tfThree resignFirstResponder];
    [self.tfFour resignFirstResponder];
    [self.tfFive resignFirstResponder];
    [self.tfSix resignFirstResponder];
}


- (IBAction)loginBtnClicked:(UIButton *)sender {
    NSString *otp = [[NSString alloc]init];
    otp = [NSString stringWithFormat:@"%@%@%@%@%@%@",self.tfOne.text,self.tfTwo.text,self.tfThree.text,self.tfFour.text,self.tfFive.text,self.tfSix.text];
    NSLog(@"%@",otp);
    if (otp.length == 6) {
        [self verifyOTp:otp];
    }else {
        [ConnectionManager alertWithToastAndDuration:@"Please Enter Complete OTP"];
    }
}


- (BOOL)textField:(UITextField *)textField
shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString
 *)string {
    self.loaderView.hidden = YES;
     self.lblStatus.hidden =  YES;
     [self.loaderView stopAnimating];
     
 if ((textField.text.length < 1) && (string.length > 0)) {
    NSInteger nextTag = textField.tag + 1;
    UIResponder* nextResponder = [textField.superview
  viewWithTag:nextTag];
    if (! nextResponder){
        [textField resignFirstResponder];
    }
    textField.text = string;
    if (nextResponder)
        [nextResponder becomeFirstResponder];
    return NO;

 }else if ((textField.text.length >= 1) && (string.length == 0)){
    // on deleteing value from Textfield

    NSInteger prevTag = textField.tag - 1;
    // Try to find prev responder
    UIResponder* prevResponder = [textField.superview
 viewWithTag:prevTag];
    if (! prevResponder){
        [textField resignFirstResponder];
    }
    textField.text = string;
    if (prevResponder)
        // Found next responder, so set it.
        [prevResponder becomeFirstResponder];
    return NO;
}
return YES;
}



-(void)verifyOTp :(NSString*)otpValue {
    self.loaderView.hidden = NO;
    [self.loaderView startAnimating];
    NSLog(@"otpValue =%@",otpValue);
    
    NSString *userId = [[NSUserDefaults standardUserDefaults]
                        stringForKey:@"userId"];
    // Create the URLSession on the default configuration
    NSURLSessionConfiguration *defaultSessionConfiguration = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *defaultSession = [NSURLSession sessionWithConfiguration:defaultSessionConfiguration];
    
    // Setup the request with URL
    NSURL *url = [NSURL URLWithString:@"url to verify otp received to mobile number"];
    NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:url];
    
    // Convert POST string parameters to data using UTF8 Encoding
    NSString *postParams = [NSString stringWithFormat:@"userid=%@&otp=%@",userId,otpValue] ;
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
            NSLog(@"Response String =%@",strr);
            
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
            NSLog(@"Response Dictionary =%@",dict);
            NSLog(@"code = %@",[dict valueForKey:@"code"]);
            
            if ([[dict valueForKey:@"code"] intValue] == 0) {
                
                if ([[dict valueForKey:@"message"]  isEqual: @"SUCCESS"]) {
                    
                    AwsVerifyVC *awsVC = [[AwsVerifyVC alloc]initWithNibName:@"AwsVerifyVC" bundle:nil];
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self.loaderView stopAnimating];
                        [self presentViewController:awsVC animated:YES completion:nil];
                    });
                }else {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        self.lblStatus.hidden =  NO;
                        self.lblStatus.text = @"OTP mismatch. Please try again";
                        self.lblStatus.textColor = [UIColor redColor];
                        self.loaderView.hidden = YES;
                        [self.loaderView stopAnimating];
                        self.btnResend.alpha = 1.0;
                        self.btnResend.enabled = YES;
                    });
                }
            }else if ([[dict valueForKey:@"code"] intValue] == 1) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    self.lblStatus.hidden =  NO;
                    
                    self.lblStatus.text = @"OTP mismatch. Please try again";
                    self.lblStatus.textColor = [UIColor redColor];
                    self.loaderView.hidden = YES;
                    [self.loaderView stopAnimating];
                    self.btnResend.alpha = 1.0;
                    self.btnResend.enabled = YES;
                });
            }else if ([[dict valueForKey:@"code"] intValue] == 2) {
                self.lblStatus.hidden =  NO;
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    self.lblStatus.text = @"OTP Expired";
                    self.lblStatus.textColor = [UIColor redColor];
                    self.loaderView.hidden = YES;
                    [self.loaderView stopAnimating];
                    self.btnResend.alpha = 1.0;
                    self.btnResend.enabled = YES;
                });
            }
        }
    }];
    // Fire the request
    [dataTask resume];
}

- (IBAction)resenBtnClicked:(UIButton *)sender {
    [self resendOtp];
}

-(void)resendOtp {
       self.tfOne.text  = @"";
       self.tfTwo.text  = @"";
       self.tfThree.text  = @"";
       self.tfFour.text  = @"";
       self.tfFive.text  = @"";
       self.tfSix.text  = @"";
    
    [self ScreenRefreshAndValidate];
    NSString *userId = [[NSUserDefaults standardUserDefaults]
    stringForKey:@"userId"];
    
    NSLog(@"user id=%@",userId);
    
    // Create the URLSession on the default configuration
    NSURLSessionConfiguration *defaultSessionConfiguration = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *defaultSession = [NSURLSession sessionWithConfiguration:defaultSessionConfiguration];

    // Setup the request with URL
    NSURL *url = [NSURL URLWithString:@"Url to resend otp"];
    NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:url];

    
    // Convert POST string parameters to data using UTF8 Encoding
    NSString *postParams = [NSString stringWithFormat:@"userid=%@",userId] ;
    NSData *postData = [postParams dataUsingEncoding:NSUTF8StringEncoding];

    // Convert POST string parameters to data using UTF8 Encoding
    [urlRequest setHTTPMethod:@"POST"];
    [urlRequest setHTTPBody:postData];

    // Create dataTask
    NSURLSessionDataTask *dataTask = [defaultSession dataTaskWithRequest:urlRequest completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        // Handle your response here
   NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *) response;
        NSLog(@"%@", httpResponse);
        [self.loaderView stopAnimating];
        if (error==nil) {
    NSString *strr = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            NSLog(@"Response Data=============%@",strr);
        }
    }];
    // Fire the request
    [dataTask resume];
}


-(void)ScreenRefreshAndValidate {
    self.tfOne.delegate = self;
         self.tfTwo.delegate = self;
         self.tfThree.delegate = self;
         self.tfFour.delegate = self;
         self.tfFive.delegate = self;
         self.tfSix.delegate = self;
      
      self.lblStatus.text = @"Waiting for OTP ...";
      self.lblStatus.textColor = [UIColor blackColor];
      self.loaderView.hidden = NO;
         self.loaderView.transform = CGAffineTransformMakeScale(2.5, 2.5);
         [self.loaderView startAnimating];
         
         self.btnResend.alpha = 0.5;
         self.btnResend.enabled = NO;
         
         // Delay execution of my block for 60 seconds.
         dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 60 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
             self.btnResend.alpha = 1.0;
             self.btnResend.enabled = YES;
         });
      
      dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 120 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
             if (self.tfOne.text.length == 0 || self.tfTwo.text.length == 0 || self.tfThree.text.length == 0 || self.tfFour.text.length == 0 ||self.tfFive.text.length == 0 || self.tfSix.text.length == 0) {
                 self.lblStatus.text = @"Time out";
                 self.lblStatus.textColor = [UIColor redColor];
                 self.loaderView.hidden = YES;
                 [self.loaderView stopAnimating];
             }
         });
}

@end
