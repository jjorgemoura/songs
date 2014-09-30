//
//  ZDProjectExportController.h
//  songs
//
//  Created by Jorge Moura on 26/09/2014.
//  Copyright (c) 2014 Jorge Moura. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>

@class ZDProjectExportController;
@class ZDProject;



@protocol ZDProjectExportControllerDelegate <NSObject>

@optional
- (void)viewControllerExportFinished:(ZDProjectExportController *)viewController;

@end



@interface ZDProjectExportController : UIViewController <MFMailComposeViewControllerDelegate>

@property (nonatomic, weak) id <ZDProjectExportControllerDelegate> delegate;
@property (nonatomic, strong) ZDProject *theSelectedZDProject;
@end
