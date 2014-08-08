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

@class ZDProject;


@interface ZDMainController : ZDCoreCollectionVC <UICollectionViewDataSource, UICollectionViewDelegate, ZDDetailsBarControllerDelegate>

- (void)changeProjectToProjectWithID:(NSString *)projectID;

@end
