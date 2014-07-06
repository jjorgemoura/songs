//
//  ZDSongCollectionViewCell.m
//  songs
//
//  Created by Jorge Moura on 06/07/14.
//  Copyright (c) 2014 Jorge Moura. All rights reserved.
//

#import "ZDSongCollectionViewCell.h"

@interface ZDSongCollectionViewCell ()

@end

@implementation ZDSongCollectionViewCell


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)drawRect:(CGRect)rect
{
    // Drawing code
    //[[self layer] setCornerRadius:20.0];
    
    //CGRect x = [[self layer] bounds];
    //CGRect y = [self bounds];
    
    
    
    UIColor *bColor = [UIColor colorWithRed:0.557 green:0.557 blue:0.576 alpha:1];
    //UIColor *bColor = [UIColor colorWithRed:1 green:0.584 blue:0 alpha:1];
    
    
    [[self layer] setBorderColor:[bColor CGColor]];
    [[self layer] setBorderWidth:1.5];
    
}


@end