
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface Utility : NSObject

+ (void)showAlertWithTitle:(NSString*)title message:(NSString*)message okAction:(BOOL)okAction okTitle:(NSString*)okTitle okBlock:(void (^)(void))okBlock cancelAction:(BOOL)cancelAction cancelBlock:(void (^)(void))cancelBlock presenter:(UIViewController *)presenter;

+ (float)heightOfString:(NSString*)str forWidth:(float)width font:(UIFont*)font;

@end
