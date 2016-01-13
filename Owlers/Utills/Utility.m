
#import "Utility.h"

@implementation Utility

+ (void)showAlertWithTitle:(NSString*)title message:(NSString*)message okAction:(BOOL)okAction okBlock:(void (^)(void))okBlock cancelAction:(BOOL)cancelAction cancelBlock:(void (^)(void))cancelBlock presenter:(UIViewController *)presenter
{
    dispatch_async(dispatch_get_main_queue(), ^{
        
        UIAlertController *alertController = [UIAlertController
                                              alertControllerWithTitle:title
                                              message:message
                                              preferredStyle:UIAlertControllerStyleAlert];
        if (cancelAction)
        {
            UIAlertAction *cancelAction = [UIAlertAction
                                           actionWithTitle:@"Cancel"
                                           style:UIAlertActionStyleCancel
                                           handler:^(UIAlertAction *action)
                                           {
                                               if (cancelBlock)
                                               {
                                                   cancelBlock();
                                               }
                                           }];
            
            [alertController addAction:cancelAction];
        }
        
        if (okAction || !cancelAction)
        {
            UIAlertAction *okAlertAction = [UIAlertAction
                                            actionWithTitle:@"Ok"
                                            style:UIAlertActionStyleDefault
                                            handler:^(UIAlertAction *action)
                                            {
                                                if (okBlock)
                                                {
                                                    okBlock();
                                                }
                                            }];
            [alertController addAction:okAlertAction];
        }
        
        [presenter presentViewController:alertController animated:YES completion:nil];
    });
}


@end
