//
//  ZDMenuController.h
//  songs
//
//  Created by Jorge Moura on 06/07/14.
//  Copyright (c) 2014 Jorge Moura. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "ZDNewProjectController.h"
#import "ZDLoadProjectController.h"


@interface ZDMenuController : UITableViewController <UITableViewDelegate, UITableViewDataSource, ZDNewProjectControllerDelegate, ZDLoadProjectControllerDelegate>

@end
