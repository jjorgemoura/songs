//
//  ZDSongsPDFManager.h
//  songs
//
//  Created by Jorge Moura on 23/07/14.
//  Copyright (c) 2014 Jorge Moura. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZDPDFEngine.h"

@class ZDProject;


@interface ZDSongsPDFManager : ZDPDFEngine

+ (NSString *)calculateFileNameFromProjectName:(NSString *)projectName;

- (void)drawPDF:(NSString *)fileName forZDproject:(ZDProject *)project;


@end
