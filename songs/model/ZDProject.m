//
//  ZDProject.m
//  songs
//
//  Created by Jorge Moura on 01/09/14.
//  Copyright (c) 2014 Jorge Moura. All rights reserved.
//

#import "ZDProject.h"
#import "ZDBar.h"


@implementation ZDProject

@dynamic band;
@dynamic bpm;
@dynamic composer;
@dynamic createDate;
@dynamic createOn;
@dynamic key;
@dynamic lyricsBy;
@dynamic name;
@dynamic year;
@dynamic bars;

- (void)addBarsObject:(ZDBar *)value {
    
    NSMutableOrderedSet* tempSet = [NSMutableOrderedSet orderedSetWithOrderedSet:[self bars]];
    [tempSet addObject:value];
    [self setBars: tempSet];
    
}

@end
