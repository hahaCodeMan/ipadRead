//
//  LoginController.h
//  MobileOffice
//
//  Created by 刘 文浩 on 12-8-4.
//  Copyright (c) 2012年 刘 文浩. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ASIFormDataRequest.h"
@interface LoginController : UIViewController <UITextFieldDelegate,ASIHTTPRequestDelegate>
{
    IBOutlet UILabel *label;
}

@property (nonatomic, retain) IBOutlet UIScrollView* loginView;
@property (nonatomic, retain) IBOutlet UITextField *userName;
@property (nonatomic, retain) IBOutlet UITextField *userPwd;
@property (nonatomic, retain) IBOutlet NSString *lastdate;

@property (nonatomic,retain) IBOutlet UIView *hiddenview;
@property (nonatomic,retain) IBOutlet UITextField *hiddentxt;
@property (nonatomic,retain) IBOutlet UITextField *hiddenpswtxt;
- (IBAction) loginBtn_click:(id)sender;

@end
