//
//  AwsVerifyVC.h
//  PhoneVerification
//
//  Created by HT-Admin on 02/10/19.
//  Copyright © 2019 HT-Admin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>
#import "ConnectionManager.h"


NS_ASSUME_NONNULL_BEGIN

@interface AwsVerifyVC : UIViewController <MFMessageComposeViewControllerDelegate> {
    int counter ; 
}
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *indicatorView;
@property (weak, nonatomic) IBOutlet UILabel *lblStatus;
- (IBAction)verifyNumBtnClicked:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UIButton *btnExit;

- (IBAction)exitBtnClicked:(UIButton *)sender;

@end

NS_ASSUME_NONNULL_END
