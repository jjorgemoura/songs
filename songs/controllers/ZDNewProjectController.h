//
//  ZDNewProjectController.h
//  songs
//
//  Created by Jorge Moura on 06/07/14.
//  Copyright (c) 2014 Jorge Moura. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ZDNewProjectController;


@protocol ZDNewProjectControllerDelegate <NSObject>

@optional
- (void)viewController:(ZDNewProjectController *)viewController willSaveZDProject:(NSString *)projectName;
- (void)viewController:(ZDNewProjectController *)viewController didSaveZDProjectWithID:(NSString *)projectID andMessage:(NSString *)message;

@end



@interface ZDNewProjectController : UIViewController

@property (nonatomic, weak) id <ZDNewProjectControllerDelegate> delegate;

@end
