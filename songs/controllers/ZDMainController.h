//
//  ZDMainController.h
//  songs
//
//  Created by Jorge Moura on 06/07/14.
//  Copyright (c) 2014 Jorge Moura. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZDCoreCollectionVC.h"

@class ZDProject;


@interface ZDMainController : ZDCoreCollectionVC <UICollectionViewDataSource, UICollectionViewDelegate>

- (void)changeProjectToProjectWithID:(NSString *)projectID;

@end
