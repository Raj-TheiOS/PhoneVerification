//
//  VerifyOtpVC.h
//  PhoneVerification
//
//  Created by HT-Admin on 02/10/19.
//  Copyright © 2019 HT-Admin. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface VerifyOtpVC : UIViewController <UITextFieldDelegate> {
    NSString *otpStr;
}
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *loaderView;
@property (weak, nonatomic) IBOutlet UILabel *lblStatus;
@property (weak, nonatomic) IBOutlet UITextField *tfOne;
@property (weak, nonatomic) IBOutlet UITextField *tfTwo;
@property (weak, nonatomic) IBOutlet UITextField *tfThree;
@property (weak, nonatomic) IBOutlet UITextField *tfFour;
@property (weak, nonatomic) IBOutlet UITextField *tfFive;
@property (weak, nonatomic) IBOutlet UITextField *tfSix;
@property (weak, nonatomic) IBOutlet UIButton *btnLogin;
@property (weak, nonatomic) IBOutlet UIButton *btnResend;

- (IBAction)loginBtnClicked:(UIButton *)sender;
- (IBAction)resenBtnClicked:(UIButton *)sender;

@end

NS_ASSUME_NONNULL_END
