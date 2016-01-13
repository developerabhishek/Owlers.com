//
//  MenuPopUpViewController.h
//  Owlers
//
//  Created by RANVIJAI on 11/01/16.
//  Copyright © 2016 JNT. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MenuItem.h"


@protocol MenuDelegate <NSObject>

- (void)menuItemClicked:(MenuItem*)item;

@end

@interface MenuPopUpViewController : UIViewController<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) NSArray *menuItems;
@property (nonatomic, weak) id<MenuDelegate> delegate;

@end
