//
//  ZDProjectDetailController.h
//  songs
//
//  Created by Jorge Moura on 26/09/2014.
//  Copyright (c) 2014 Jorge Moura. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZDProjectDetailController : UIViewController <NSURLSessionDelegate, NSURLSessionTaskDelegate, NSURLSessionDownloadDelegate>


@property (nonatomic, copy) NSString *songProjectName;
@property (nonatomic, copy) NSString *bandName;
@property (nonatomic, copy) NSString *composerName;
@property (nonatomic, copy) NSString *lyricsByName;
@property (nonatomic, copy) NSString *year;
@property (nonatomic, copy) NSString *bpm;
@property (nonatomic, copy) NSString *songKey;
@property (nonatomic, copy) NSString *numberBars;
@property (nonatomic, copy) NSString *timeSignature;


@end
