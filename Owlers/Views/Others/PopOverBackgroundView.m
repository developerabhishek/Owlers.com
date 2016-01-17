//
//  CustomBackgroundVIew.m
//  JsonModelTest
//
//  Created by RANVIJAI on 18/06/15.
//  Copyright (c) 2015 PHILIPS. All rights reserved.
//

#import "PopOverBackgroundView.h"

@implementation PopOverBackgroundView

+ (CGFloat)arrowHeight{
    return 0.0;
}

+(UIEdgeInsets)contentViewInsets{
    return UIEdgeInsetsMake(0 , 0, 0, 0);
}

- (CGFloat) arrowOffset {
    return 0;
}

- (void) setArrowOffset:(CGFloat)arrowOffset {
}

- (UIPopoverArrowDirection)arrowDirection {
    return UIPopoverArrowDirectionAny;
}

- (void)setArrowDirection:(UIPopoverArrowDirection)arrowDirection {
   
}

+(CGFloat)arrowBase{
    return 0.0;
}

+ (BOOL)wantsDefaultContentAppearance{
    return NO;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.layer.shadowColor = [[UIColor clearColor] CGColor];
}



@end
