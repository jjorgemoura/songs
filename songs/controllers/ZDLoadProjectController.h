//
//  ZDLoadProjectController.h
//  songs
//
//  Created by Jorge Moura on 06/07/14.
//  Copyright (c) 2014 Jorge Moura. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZDCoreDataTableVC.h"

@class ZDLoadProjectController;


@protocol ZDLoadProjectControllerDelegate <NSObject>

@optional
- (void)viewController:(ZDLoadProjectController *)viewController willLoadZDProject:(NSString *)projectName andProjectID:(NSString *)projectID;
- (void)viewController:(ZDLoadProjectController *)viewController didLoadZDProjectWithID:(NSString *)projectID;

@end



@interface ZDLoadProjectController : ZDCoreDataTableVC <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, weak) id <ZDLoadProjectControllerDelegate> delegate;

@end
