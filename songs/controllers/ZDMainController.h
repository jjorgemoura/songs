//
//  ZDMainController.h
//  songs
//
//  Created by Jorge Moura on 06/07/14.
//  Copyright (c) 2014 Jorge Moura. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZDCoreCollectionVC.h"
#import "ZDDetailsBarController.h"
#import "ZDAddInsertBarsController.h"
#import "ZDEditBarController.h"


@class ZDProject;


@interface ZDMainController : ZDCoreCollectionVC <UICollectionViewDataSource, UICollectionViewDelegate, ZDDetailsBarControllerDelegate, ZDAddInsertBarsControllerDelegate, ZDEditBarControllerDelegate>

- (void)changeProjectToProjectWithID:(NSString *)projectID;

@end
