//
//  ZDMultipleSelectionController.h
//  songs
//
//  Created by Jorge Moura on 07/10/2014.
//  Copyright (c) 2014 Jorge Moura. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ZDMultipleSelectionController;


@protocol ZDMultipleSelectionControllerDelegate <NSObject>

@optional

- (void)viewControllerWillDeleteZDBars:(ZDMultipleSelectionController *)viewController;
- (void)viewControllerDidDeleteZDBars:(ZDMultipleSelectionController *)viewController;
- (void)viewControllerDidCancel:(ZDMultipleSelectionController *)viewController;

@end






@interface ZDMultipleSelectionController : UIViewController

@property (nonatomic, strong) NSArray *theBarsList;
@property (nonatomic, weak) id <ZDMultipleSelectionControllerDelegate> delegate;


@end
