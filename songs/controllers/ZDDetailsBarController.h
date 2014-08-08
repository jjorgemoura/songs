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
- (void)viewController:(ZDDetailsBarController *)viewController willSaveZDBar:(ZDBar *)bar;
- (void)viewController:(ZDDetailsBarController *)viewController didSaveZDBar:(ZDBar *)bar;
- (void)viewControllerDidCancel:(ZDDetailsBarController *)viewController;

@end



@interface ZDDetailsBarController : UIViewController

@property (nonatomic, strong) ZDBar *theBar;
@property (nonatomic, weak) id <ZDDetailsBarControllerDelegate> delegate;

@end
