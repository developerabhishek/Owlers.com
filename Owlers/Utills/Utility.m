
#import "Utility.h"

@implementation Utility

+ (void)showAlertWithTitle:(NSString*)title message:(NSString*)message okAction:(BOOL)okAction okTitle:(NSString*)okTitle okBlock:(void (^)(void))okBlock cancelAction:(BOOL)cancelAction cancelBlock:(void (^)(void))cancelBlock presenter:(UIViewController *)presenter
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
            NSString *ok = @"Ok";
            if (okTitle.length) {
                ok = okTitle;
            }
            UIAlertAction *okAlertAction = [UIAlertAction
                                            actionWithTitle:ok
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


+ (float)heightOfString:(NSString*)str forWidth:(float)width font:(UIFont*)font{

    CGSize constraint = CGSizeMake(width,NSUIntegerMax);
    NSMutableParagraphStyle *style = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
    [style setLineBreakMode:NSLineBreakByWordWrapping];
    
    NSDictionary *attributes = @{NSFontAttributeName: font, NSParagraphStyleAttributeName: style};
    
    CGRect myStringSize = [str boundingRectWithSize:constraint
                                                      options:(NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading)
                                                   attributes:attributes
                                                      context:nil];
    myStringSize.size = CGSizeMake(ceil(myStringSize.size.width), ceil(myStringSize.size.height)) ;
    return ceil(myStringSize.size.height);
}


@end
