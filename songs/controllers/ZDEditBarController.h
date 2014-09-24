//
//  ZDEditBarController.h
//  songs
//
//  Created by Jorge Moura on 19/09/2014.
//  Copyright (c) 2014 Jorge Moura. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ZDEditBarController;
@class ZDBar;


@protocol ZDEditBarControllerDelegate <NSObject>

@optional
- (void)viewController:(ZDEditBarController *)viewController willEditBar:(ZDBar *)bar;
- (void)viewController:(ZDEditBarController *)viewController didEditBar:(ZDBar *)bar;
- (void)viewControllerEditBarCancel:(ZDEditBarController *)viewController;

@end



@interface ZDEditBarController : UIViewController

@property (nonatomic, weak) id <ZDEditBarControllerDelegate> delegate;
@property (nonatomic, strong) ZDBar *theSelectedZDBar;

@end
