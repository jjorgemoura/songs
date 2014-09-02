//
//  ZDNote.h
//  songs
//
//  Created by Jorge Moura on 01/09/14.
//  Copyright (c) 2014 Jorge Moura. All rights reserved.
//

#import <Foundation/Foundation.h>


typedef NS_ENUM(NSInteger, ZDMusicNote) {
    C = 1,
    CSharp = 2,
    D = 3,
    DSharp = 4,
    E = 5,
    F = 6,
    FSharp = 7,
    G = 8,
    GSharp = 9,
    A = 10,
    ASharp = 11,
    B = 12
};




@interface ZDNote : NSObject


@property (nonatomic, readonly) NSInteger note;
@property (nonatomic) ZDMusicNote musicNote;
@property (nonatomic, copy, readonly) NSString *noteText;

+ (NSArray *)list;
+ (ZDNote *)noteWithHalfSteps:(NSInteger)halfsteps fromNote:(ZDNote *)note;


- (instancetype)initWithNote:(ZDMusicNote)note;


@end
