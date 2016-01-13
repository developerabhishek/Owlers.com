//
//  SharedPreferences.h
//  Owlers
//
//  Created by Abhishek on 05/01/16.
//  Copyright © 2016 JNT. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface SharedPreferences : NSObject

+ (SharedPreferences*) sharedInstance;
+ (BOOL)isNetworkAvailable;
- (void)showCommonAlertWithMessage:(NSString *)alertMessage withObject:(UIViewController *)controllerObject;
- (BOOL)isLogin;
- (void)logoutUser;
- (NSString *)getUserID;

@end
