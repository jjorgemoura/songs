//
//  ZDDetailsBarControllerViewController.h
//  songs
//
//  Created by Jorge Moura on 24/07/14.
//  Copyright (c) 2014 Jorge Moura. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ZDBar;
@class ZDDetailsBarController;


@protocol ZDDetailsBarControllerDelegate <NSObject>

@optional
- (void)viewController:(ZDDetailsBarController *)viewController willEditZDBar:(ZDBar *)bar;
- (void)viewController:(ZDDetailsBarController *)viewController didEditZDBar:(ZDBar *)bar;
- (void)viewController:(ZDDetailsBarController *)viewController willDeleteZDBar:(ZDBar *)bar;
- (void)viewController:(ZDDetailsBarController *)viewController didDeleteZDBar:(ZDBar *)bar;
- (void)viewControllerDidCancel:(ZDDetailsBarController *)viewController;

@end



@interface ZDDetailsBarController : UIViewController

@property (nonatomic, strong) ZDBar *theBar;
@property (nonatomic, weak) id <ZDDetailsBarControllerDelegate> delegate;
@property (nonatomic, weak) UIAlertController *theConfirmationAlertBox;

@end
