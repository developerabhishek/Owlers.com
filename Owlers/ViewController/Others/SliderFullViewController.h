//
//  SliderFullViewController.h
//  Owlers
//
//  Created by RANVIJAI on 19/01/16.
//  Copyright © 2016 JNT. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SliderFullViewController : UIViewController<UIPageViewControllerDataSource>

@property (strong, nonatomic) NSMutableArray *pageDatalist;

- (IBAction)backBtnAction:(id)sender;

@end
