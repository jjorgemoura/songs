//
//  ZDSongCollectionViewCell.m
//  songs
//
//  Created by Jorge Moura on 06/07/14.
//  Copyright (c) 2014 Jorge Moura. All rights reserved.
//

#import "ZDSongCollectionViewCell.h"

@interface ZDSongCollectionViewCell ()

@property(weak) IBOutlet UILabel *mainLabel;
@property(weak) IBOutlet UILabel *auxLabel;

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

- (void)mainText:(NSString *)text {
    
    [[self mainLabel] setText:text];
}

- (void)auxText:(NSString *)text {
    
    [[self auxLabel] setText:text];
}

- (void)color:(UIColor *)color {

    [self setBackgroundColor:color];
}

- (void)borderColor:(UIColor *)color {

    [[self layer] setBorderColor:[[UIColor redColor] CGColor]];
}

@end
