//
//  CustomCell3.h
//  Owlers
//
//  Created by Biprajit Biswas on 29/10/15.
//  Copyright © 2015 JNT. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomCell3 : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *label1;
@property (strong, nonatomic) IBOutlet UILabel *label2;
@property (strong, nonatomic) IBOutlet UILabel *label3;
@property (strong, nonatomic) IBOutlet UIView *viewd;


@property (nonatomic,strong) IBOutlet UILabel *rupees_Lab;
@property(nonatomic,strong) IBOutlet UILabel *time_label;
@property(nonatomic,strong) IBOutlet UILabel *date_label;
@property(nonatomic,strong) IBOutlet UILabel *description_label;
@property(nonatomic,strong) IBOutlet UILabel *condition_label;
@end
