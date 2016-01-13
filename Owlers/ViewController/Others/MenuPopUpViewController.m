//
//  MenuPopUpViewController.m
//  Owlers
//
//  Created by RANVIJAI on 11/01/16.
//  Copyright © 2016 JNT. All rights reserved.
//

#import "MenuPopUpViewController.h"
#import "MenuTableViewCell.h"

@interface MenuPopUpViewController ()

@end

@implementation MenuPopUpViewController

#pragma marks UITableView Delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
   return self.menuItems.count;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.delegate menuItemClicked:(MenuItem*)[self.menuItems objectAtIndex:indexPath.row]];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MenuTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"reuseMenuCell"];
    cell.displayName.text = [(MenuItem*)[self.menuItems objectAtIndex:indexPath.row] displayName];
    return cell;
}

@end
