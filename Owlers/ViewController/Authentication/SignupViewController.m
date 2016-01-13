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
//#import "AFHTTPRequestOperationManager.h"
#import "SVProgressHUD.h"
//#import <FacebookSDK/FacebookSDK.h>

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
NSDictionary *parsedObject;

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
            UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:nil message:message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alertView show];
        }
        else
        {
            [self performSelector:@selector(signupInapplication) withObject:nil];

           // [self webServicePlans];
        }
}

-(void)signupInapplication
{

    if ([[ConnectionManager getSharedInstance] isConnectionAvailable])
    {
        dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void){
            //Background Thread

            [self.continueBtn setEnabled:NO];

            NSString *urlString = [[NSString stringWithFormat:@"%@/signup.php?name=%@&email=%@&password=%@&phone=%@&source=iPhone&@&mac_addr=4545.7765.767",BaseUrl,self.userNameTxtFld.text,self.emailTxtFld.text,self.pwdTxtFld.text,self.mobileNoTxtFld.text,self.confirmPassTxtFld.text]stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            NSURL *url = [[NSURL alloc] initWithString:urlString];

            NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url];


            [NSURLConnection sendAsynchronousRequest:request queue:[[NSOperationQueue alloc] init] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error)

             {
                 dispatch_async(dispatch_get_main_queue(), ^(void){
                     //Run UI Updates
                     if (data.length > 0)
                     {
                         [self.continueBtn setEnabled:YES];

                         parsedObject = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];

                         NSLog(@"parsedObject =%@",parsedObject);


                         if ([[parsedObject valueForKey:@"status"]  isEqual: @"success"])
                         {
                             UIAlertView  *alertView = [[UIAlertView alloc] initWithTitle:nil message:[parsedObject valueForKey:@"message"] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                             [alertView show];

                             NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
                             [user setObject:[parsedObject objectForKey:@"user_id"] forKey:@"userID"];
//                             ProductViewController *product = [[ProductViewController alloc]init];
//                             [self.navigationController pushViewController:product animated:YES];
                             [self signUpSuccess];
                         }
                         else
                         {
                             UIAlertView  *alertView = [[UIAlertView alloc] initWithTitle:nil message:[parsedObject valueForKey:@"message"] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                             [alertView show];
                         }
                     }

                 });
             }];
        });

    }
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

    if (!token) {

    } else {

        if ([FBSDKAccessToken currentAccessToken]) {


            [self fetchUserInfo];


        }}     }

-(void)fetchUserInfo
{
    [[[FBSDKGraphRequest alloc] initWithGraphPath:@"me" parameters:nil]
     startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
         if (!error) {
             NSLog(@"fetched user:%@", result);

//             ProductViewController *product = [[ProductViewController alloc]init];
//             [self.navigationController pushViewController:product animated:YES];
             [self signUpSuccess];

         }else{
             // [SVProgressHUD dismiss];
             UIAlertView *alertView=[[UIAlertView alloc] initWithTitle:@"Could not connect to server" message:[error localizedDescription] delegate:nil cancelButtonTitle:nil otherButtonTitles:@"Ok", nil];
             [alertView show];
         }
     }];
}



- (IBAction)googlebtnaction:(id)sender {
    [self hideKeyBoard];


}



//#pragma mark Webservice ............
//
////-(void)webServicePlans{
////
////
////    if (![[ConnectionManager getSharedInstance] isConnectionAvailable])
////    {
////
////
////        return;
////    }
////
////
////     NSString *urlString = [[NSString stringWithFormat:@"%@/signup.php?name=%@&email=%@&password=%@&phone=%@&source=iPhone&@&mac_addr=4545.7765.767",BaseUrl,self.userNameTf.text,self.emailTF.text,self.pwdTF.text,self.mobilenotf.text] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
////    [SVProgressHUD showWithStatus:@"Loading.." maskType:SVProgressHUDMaskTypeGradient];
////
////    AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc] init];
////
////    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
////
////   // [manager.requestSerializer setValue:[userdef objectForKey:@"access_token"] forHTTPHeaderField:@"Authorization"];
////
////
////
////    [manager GET:urlString parameters:nil
////          success:^(AFHTTPRequestOperation *operation, id responseObject) {
////             // globalManager.isRequestFetchedForInboxPlan=YES;
////              NSDictionary *dataDictionary = [NSJSONSerialization JSONObjectWithData:responseObject options:0 error:nil];
////              NSLog(@"web service PLANS %@",dataDictionary);
////          /*    if (dataDictionary.count<=0 ||dataDictionary==0 || [[dataDictionary valueForKey:@"message"] isEqualToString:@"No Plan Found"]) {
////
////                  if (globalManager.isRequestFetchedForTimeLine &&
////                      globalManager.isRequestFetchedForInboxPlan &&
////                      globalManager.isRequestFetchedForInboxSlap &&
////                      globalManager.isRequestFetchedForInboxSlapall){
////                      [SVProgressHUD dismiss];
////                  }
////                  return ;
////              }
////
////              arr_planList =nil;
////              arr_planList = [NSMutableArray new];
////              //  [arr_planList removeAllObjects];
////              NSArray *temp_arr =  [dataDictionary objectForKey:@"data"];
////              // NSDictionary *dic_temp = [temp_arr objectAtIndex:0];
////
////
////              for (NSDictionary *dic in temp_arr) {
////
////                  PlanLists *events = [[PlanLists alloc] initWithDictionary:dic error:nil];
////
////                  [arr_planList addObject:events];
////                  [globalManager.arr_planList addObject:events];
////              }
////
////              self.segmented.selectedSegmentIndex=0;
////              if (globalManager.isRequestFetchedForTimeLine &&
////                  globalManager.isRequestFetchedForInboxPlan &&
////                  globalManager.isRequestFetchedForInboxSlap &&
////                  globalManager.isRequestFetchedForInboxSlapall){
////                  [SVProgressHUD dismiss];
////              }*/
////             [SVProgressHUD dismiss];
////
////
////          } failure:^(AFHTTPRequestOperation *operation,NSError *error){
////
////
////              NSLog(@"error%@",error.description);
////              [SVProgressHUD dismiss];
////
////            /*  [[tView viewWithTag:8787] removeFromSuperview];
////              UIView *netconnectionview = [[UIView alloc]initWithFrame:CGRectMake(0, self.view.frame.size.height/2-50, self.view.frame.size.width,100)];
////              [netconnectionview setTag:8787];
////              UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, netconnectionview.frame.size.width-20,50)];
////              [label setTextColor:[UIColor whiteColor]];
////              [netconnectionview addSubview:label];
////              [label setNumberOfLines:0];
////              [label setTextAlignment:NSTextAlignmentCenter];
////              [label setLineBreakMode:NSLineBreakByWordWrapping];
////              [label setFont:[UIFont fontWithName:@"Titillium-Light" size:17]];
////              [label setText:@"Unable to load data from the server. Tap to retry"];
////              UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(fetchAgainPlans:)];
////              [netconnectionview setUserInteractionEnabled:YES];
////              [netconnectionview addGestureRecognizer:tap];
////
////
////              [tView addSubview:netconnectionview];
////              */
////
////          }];
////}
//
////-(void)fetchAgainPlans:(UITapGestureRecognizer *)sender{
////   // [[tView viewWithTag:8787] removeFromSuperview];
////
////    [self webServicePlans];
////}


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
