//
//  SignupViewController.m
//  Owlers
//
//  Created by Biprajit Biswas on 24/09/15.
//  Copyright (c) 2015 JNT. All rights reserved.
//

#import "SignupViewController.h"
#import "Connectionmanager.h"
#import "Header.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import "ProductViewController.h"
#import "SVProgressHUD.h"
#import "SharedPreferences.h"
#import "NetworkManager.h"


@interface SignupViewController ()
@property (weak, nonatomic) IBOutlet UIButton *continueBtn;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) UIView *currentResponderContainer;
@property (strong, nonatomic) IBOutlet UITextField *userNameTxtFld;
@property (strong, nonatomic) IBOutlet UITextField *emailTxtFld;
@property (strong, nonatomic) IBOutlet UITextField *pwdTxtFld;
@property (strong, nonatomic) IBOutlet UITextField *confirmPassTxtFld;
@property (strong, nonatomic) IBOutlet UITextField *mobileNoTxtFld;

@end

@implementation SignupViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.scrollView.delaysContentTouches = YES;
}

- (IBAction)backbtnaction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)continuebtnaction:(id)sender {
    [self hideKeyBoard];
    
    NSString *message = [[NSString alloc]init];
    if ([self.userNameTxtFld.text length] == 0)
    {
        message = @"Please enter User Name";
    }
    else if ([self.emailTxtFld.text length] == 0)
    {
        message = @"Please enter your emailId";
    }
    else if ([self.pwdTxtFld.text length] == 0)
    {
        message = @"Please enter password";
    }
    else if ([self.confirmPassTxtFld.text length] == 0)
    {
        message = @"Please enter confirm password";
    }
    else if ([self.confirmPassTxtFld.text length] != [self.pwdTxtFld.text length])
    {
        message = @"Password does not match";
    }
    else if ([self.mobileNoTxtFld.text length] == 0)
    {
        message = @"Please enter your mobileno";
    }


        if (message.length != 0)
        {
            [[SharedPreferences sharedInstance] showCommonAlertWithMessage:message withObject:self];
        }
        else
        {
            [self performSelector:@selector(signupInapplication) withObject:nil];
        }
}

-(void)signupInapplication
{

    [NetworkManager signUpWithEmail:self.emailTxtFld.text andPassword:self.pwdTxtFld.text andMobile:self.mobileNoTxtFld.text andName:self.userNameTxtFld.text withComplitionHandler:^(id result, NSError *err) {
        
        [[SharedPreferences sharedInstance] showCommonAlertWithMessage:[result valueForKey:@"message"] withObject:self];
        
        if ([[result valueForKey:@"status"]  isEqual: @"success"])
        {
            NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
            [userDefaults setObject:[result objectForKey:@"user_id"] forKey:@"userID"];
            [userDefaults synchronize];            
        }
    }];
}



- (IBAction)fbbtnaction:(id)sender {

    [self hideKeyBoard];
    
    FBSDKLoginManager *login = [[FBSDKLoginManager alloc] init];
    [login
     logInWithReadPermissions: @[@"public_profile"]
     fromViewController:self
     handler:^(FBSDKLoginManagerLoginResult *result, NSError *error) {
         if (error) {
             NSLog(@"Process error");
         } else if (result.isCancelled) {
             NSLog(@"Cancelled");
         } else {
             NSLog(@"Logged in");
             [self fetchUserInfo];
         }
     }];
}



#pragma mark Notification method changed

-(void)_accessTokenChanged:(NSNotification *)notification
{
    FBSDKAccessToken *token = notification.userInfo[FBSDKAccessTokenChangeNewKey];

    if (token) {
        if ([FBSDKAccessToken currentAccessToken]) {
            [self fetchUserInfo];
        }
    }
}

-(void)fetchUserInfo
{
    [[[FBSDKGraphRequest alloc] initWithGraphPath:@"me" parameters:nil]
     startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
         if (!error) {
             [self signUpSuccess];
         }else{
             
             [[SharedPreferences sharedInstance] showCommonAlertWithMessage:[error localizedDescription] withObject:self];
         }
     }];
}

- (IBAction)googlebtnaction:(id)sender {
    [self hideKeyBoard];


}
-(BOOL)textFieldShouldReturn:(UITextField*)textField
{
    NSInteger nextTag = textField.tag + 1;
    // Try to find next responder
    UIResponder* nextResponder = [self.scrollView viewWithTag:nextTag];
    NSLog(@"textField =%@",textField.superview);
    if (nextResponder && [nextResponder isMemberOfClass:[UITextField class]]) {
        // Found next responder, so set it.
        [nextResponder becomeFirstResponder];
    } else {
        // Not found, so remove keyboard.
        [textField resignFirstResponder];
    }
    return NO; // We do not want UITextField to insert line-breaks.
}

-(void)keyboardDidShow:(NSNotification*)aNotification
{
    // move up the screen to the top of the keyboard so that user input fields will be still visible after keyboard appears
    NSDictionary* info = [aNotification userInfo];
    CGRect kbRect = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    kbRect = [self.view convertRect:kbRect toView:nil];
    CGPoint point = self.scrollView.contentOffset;
    float diff = (self.currentResponderContainer.frame.origin.y + self.scrollView.frame.origin.y + self.currentResponderContainer.frame.size.height) - kbRect.origin.y;
    if (diff > 0) {
        point.y = diff;
        self.scrollView.contentOffset = point;
    }
}


-(void)keyboardDidHide:(NSNotification*)aNotification
{
    // move back the screen to normal position how it was when keyboard was not visible
    
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    self.currentResponderContainer = textField.superview;
    return  YES;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    // add keyboard notification
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidHide:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    
    [super viewWillDisappear:animated];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self hideKeyBoard];
}

- (void)hideKeyBoard {
    [self.userNameTxtFld resignFirstResponder];
    [self.emailTxtFld resignFirstResponder];
    [self.pwdTxtFld resignFirstResponder];
    [self.confirmPassTxtFld resignFirstResponder];
    [self.mobileNoTxtFld resignFirstResponder];
}

- (void)signUpSuccess {
    // If SignUp screen is came from Product screen then pop it from stack else create the product view controller and set it on top of stack without signup screen
    NSArray *arr = [self.navigationController viewControllers];
    for (UIViewController *controller in arr) {
        if ([controller isMemberOfClass:[ProductViewController class]]) {
            [self.navigationController popToViewController:controller animated:YES];
            return;
        }
    }
    ProductViewController *productCon = [self.storyboard instantiateViewControllerWithIdentifier:@"ProductViewController"];
    NSMutableArray *marr = [NSMutableArray arrayWithArray:arr];
    [marr addObject:productCon];
    [self.navigationController setViewControllers:marr animated:NO];
}


@end
