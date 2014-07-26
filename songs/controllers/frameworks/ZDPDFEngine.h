//
//  ZDPDFEngine.h
//  songs
//
//  Created by Jorge Moura on 23/07/14.
//  Copyright (c) 2014 Jorge Moura. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface ZDPDFEngine : NSObject


- (void)drawLineFromPoint:(CGPoint)from toPoint:(CGPoint)to;

- (void)drawImage:(UIImage *)image inRect:(CGRect)rect;

- (void)drawText:(NSString *)textToDraw inFrame:(CGRect)frameRect;

- (void)drawText:(NSString *)textToDraw inFrame:(CGRect)frameRect withFrameSettings:(NSString *)settings;



@end
