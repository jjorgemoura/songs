//
//  ZDAddInsertBarsController.h
//  songs
//
//  Created by Jorge Moura on 08/08/14.
//  Copyright (c) 2014 Jorge Moura. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ZDBar;
@class ZDSongBlock;
@class ZDAddInsertBarsController;


@protocol ZDAddInsertBarsControllerDelegate <NSObject>

@optional
- (void)viewController:(ZDAddInsertBarsController *)viewController willInsertXBars:(NSNumber *)barsQuantity ofType:(ZDSongBlock *)barBlockType beforeTheCurrentBar:(BOOL)before;
- (void)viewController:(ZDAddInsertBarsController *)viewController didInsertXBars:(NSNumber *)barsQuantity ofType:(ZDSongBlock *)barBlockType beforeTheCurrentBar:(BOOL)before;
- (void)viewControllerXBarsDidCancel:(ZDAddInsertBarsController *)viewController;

@end


@interface ZDAddInsertBarsController : UIViewController

@property (nonatomic, strong) ZDBar *theSelectedZDBar;
@property (nonatomic, weak) id <ZDAddInsertBarsControllerDelegate> delegate;

@end
