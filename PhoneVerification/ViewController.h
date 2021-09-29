//
//  ViewController.h
//  PhoneVerification
//
//  Created by HT-Admin on 27/09/19.
//  Copyright © 2019 HT-Admin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>


@interface ViewController : UIViewController <UINavigationControllerDelegate , UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *tfEnterNum;
- (IBAction)continueBtnClicked:(UIButton *)sender;



@end

