//
//  LoginViewController.m
//  Owlers
//
//  Created by Biprajit Biswas on 25/09/15.
//  Copyright (c) 2015 JNT. All rights reserved.
//

#import "LoginViewController.h"
#import "ForgotpasswordViewController.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import "Connectionmanager.h"
#import "Header.h"
#import "OwlersViewController.h"
#import "ProductViewController.h"
#import "VerificationViewController.h"
#import <GoogleOpenSource/GoogleOpenSource.h>
#import <GooglePlus/GooglePlus.h>
#import "AppDelegate.h"
#import "SharedPreferences.h"
#import "NetworkManager.h"

static NSString * const kClientID = @"509181039153-i4mnrf976n999ornrh2eafeeg1cf4oka.apps.googleusercontent.com";

@interface LoginViewController () <UIAlertViewDelegate, GPPSignInDelegate>

@end


@implementation LoginViewController

@synthesize googleloginaction;

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    // Do any additional setup after loading the view from its nib.
    if ([[[NSUserDefaults standardUserDefaults] valueForKey:@"CheckSelected"] integerValue] == 1)
    {
        self.emailtxtfld.text = [[NSUserDefaults standardUserDefaults] valueForKey:@"userEmail"];
    }

    if ([FBSDKAccessToken currentAccessToken]) {
       
    }
    self.fbloginaction.readPermissions = @[@"public_profile", @"email", @"user_friends"];
    
    UITapGestureRecognizer *tapGestureRecognizer1 = [[UITapGestureRecognizer alloc]initWithTarget:self
                                                                                           action:@selector(keyBoardHidden)];
    [self.view addGestureRecognizer:tapGestureRecognizer1];
    
    /**************[GOOGLE SIGNIN START]*********/
//    
//    GPPSignIn *signIn = [GPPSignIn sharedInstance];
//    signIn.shouldFetchGooglePlusUser = YES;
//    //signIn.shouldFetchGoogleUserEmail = YES;  // Uncomment to get the user's email
//    
//    // You previously set kClientId in the "Initialize the Google+ client" step
//    signIn.clientID = kClientID;
//    
//    // Uncomment one of these two statements for the scope you chose in the previous step
//    signIn.scopes = @[ kGTLAuthScopePlusLogin ];  // "https://www.googleapis.com/auth/plus.login" scope
//    //signIn.scopes = @[ @"profile" ];            // "profile" scope
//    
//    // Optional: declare signIn.actions, see "app activities"
//    signIn.delegate = self;
    
    /************[GOOGLE SIGNIN END]**********/
}

- (IBAction)backbtnaction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)loginbtnaction:(id)sender {
    
    
    NSString *message = @"";
    
    if (self.emailtxtfld.text.length <= 0)
    {
        message = @"Please enter your email id";
    }else if (![self validateEmail: self.emailtxtfld.text])
    {
        message = @"Please enter a valid email id";
    }else if (self.pwdtextfld.text.length <= 0)
    {
        message = @"Please enter your password";
    }
    
    if (message.length > 0)
    {
        [[SharedPreferences sharedInstance] showCommonAlertWithMessage:message withObject:self];
    }
    else
    {
        [self performSelector:@selector(logInUserInApplication) withObject:nil afterDelay:0.0f];
    }
}

-(void)logInUserInApplication
{
    [NetworkManager loginWithEmail:self.emailtxtfld.text andPassword:self.pwdtextfld.text withComplitionHandler:^(id result, NSError *err) {
        
        if (result && [[result valueForKey:@"status"]  isEqual: @"success"])
        {
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            [defaults setObject:[result valueForKey:@"user_email"] forKey:@"userEmail"];
            [defaults setObject:[result valueForKey:@"user_id"] forKey:@"userID"];
            [defaults synchronize];

            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"JNT" message:[result valueForKey:@"message"] preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                       handler:^(UIAlertAction * action)
                                 {
                                     [self.navigationController popViewControllerAnimated:YES];
                                     [self loginSuccess];
                                     
                                 }];
            [alertController addAction:ok];
            [self presentViewController:alertController animated:YES completion:nil];
        }else{
            [[SharedPreferences sharedInstance] showCommonAlertWithMessage:[result valueForKey:@"message"] withObject:self];
        }
    }];
}

- (BOOL)validateEmail:(NSString *)email1
{
    NSString *emailRegex = @ "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:email1];
}

- (IBAction)fbloginaction:(id)sender
{
    self.fbloginaction.readPermissions = @[@"public_profile"];
    FBSDKLoginManager *login = [[FBSDKLoginManager alloc] init];
    
    [login
     logInWithReadPermissions: @[@"public_profile",@"email"]
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
    if (!token) {
    } else {
        if ([FBSDKAccessToken currentAccessToken]) {
            [self fetchUserInfo];
        }
    }
}

-(void)fetchUserInfo
{
    NSMutableDictionary* parameters = [NSMutableDictionary dictionary];
    [parameters setValue:@"id, name, email" forKey:@"fields"];

    [[[FBSDKGraphRequest alloc] initWithGraphPath:@"me" parameters:parameters]
     startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
         if (!error) {
             [self pushToVerificationControllerWith:@{@"user_id" : [result valueForKey:@"id"], @"user_email" : [result valueForKey:@"email"],@"name": [result valueForKey:@"name"]}];
             
         }else{

             [[SharedPreferences sharedInstance] showCommonAlertWithMessage:@"Could not connect to server" withObject:self];
         }
     }];
    
}

- (IBAction)googleloginaction:(id)sender;
{
    GPPSignIn *signIn = [GPPSignIn sharedInstance];
    signIn.delegate = self;
    signIn.shouldFetchGooglePlusUser = YES;
    signIn.shouldFetchGoogleUserEmail = YES;
    
    signIn.clientID = kClientID;
    signIn.scopes = [NSArray arrayWithObjects:kGTLAuthScopePlusLogin,nil];
    
    signIn.actions = [NSArray arrayWithObjects:@"https://www.googleapis.com/auth/userinfo.profile",nil];
    [[GPPSignIn sharedInstance] authenticate];
}


-(void)finishedWithAuth:(GTMOAuth2Authentication *)auth error:(NSError *)error{
    
    NSLog(@"Received Error %@  and auth object==%@",error,auth);
    
    if (error) {
        // Do some error handling here.
    } else {
      //  [self refreshInterfaceBasedOnSignIn];
        
        NSLog(@"email %@ ",[NSString stringWithFormat:@"Email: %@",[GPPSignIn sharedInstance].authentication.userEmail]);
        NSLog(@"Received error %@ and auth object %@",error, auth);
        
        // 1. Create a |GTLServicePlus| instance to send a request to Google+.
        GTLServicePlus* plusService = [[GTLServicePlus alloc] init] ;
        plusService.retryEnabled = YES;
        
        // 2. Set a valid |GTMOAuth2Authentication| object as the authorizer.
        [plusService setAuthorizer:[GPPSignIn sharedInstance].authentication];
        
        
        GTLQueryPlus *query = [GTLQueryPlus queryForPeopleGetWithUserId:@"me"];
        
        // *4. Use the "v1" version of the Google+ API.*
        plusService.apiVersion = @"v1";
        
        [plusService executeQuery:query
                completionHandler:^(GTLServiceTicket *ticket,
                                    GTLPlusPerson *person,
                                    NSError *error) {
                    if (!error) {
                        
                        [self pushToVerificationControllerWith:@{@"user_id" : person.identifier, @"user_email" : [GPPSignIn sharedInstance].authentication.userEmail ,@"name": person.displayName}];
                    }
                }];
    }
}
- (void)pushToVerificationControllerWith:(NSDictionary *)data{
    
    NSUserDefaults *defauls = [NSUserDefaults standardUserDefaults];
    [defauls setObject:[data objectForKey:@"user_email"] forKey:@"userEmail"];
    [defauls setObject:[data objectForKey:@"name"] forKey:@"name"];
    [defauls setObject:[data objectForKey:@"user_id"] forKey:@"userID"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [self performSegueWithIdentifier:@"segueVerification" sender:nil];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

-(void)keyBoardHidden
{
    for (UIView *view in [self.view subviews]) {
        if ([view isKindOfClass:[UITextField class]])
        {
            UITextField *textField = (UITextField *)view;
            [textField resignFirstResponder];
        }
    }
}

- (void)loginSuccess {
    // If Login screen is came from Product screen then pop it from stack else create the product view controller and set it on top of stack without Login screen
    NSArray *arr = [self.navigationController viewControllers];
    for (UIViewController *controller in arr) {
        if ([controller isMemberOfClass:[ProductViewController class]]) {
            [self.navigationController popToViewController:controller animated:NO];
            return;
        }
    }

    ProductViewController *productCon = [self.storyboard instantiateViewControllerWithIdentifier:@"ProductViewController"];
    NSMutableArray *marr = [NSMutableArray arrayWithArray:arr];
    [marr addObject:productCon];
    [self.navigationController setViewControllers:marr animated:NO];
}

@end
