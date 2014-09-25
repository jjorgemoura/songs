//
//  ZDChordType.m
//  songs
//
//  Created by Jorge Moura on 01/09/14.
//  Copyright (c) 2014 Jorge Moura. All rights reserved.
//

#import "ZDChordType.h"

@implementation ZDChordType


//---------------------------------------------------------------------------------------
//---------------------------------------------------------------------------------------
#pragma mark - Class Methods
//---------------------------------------------------------------------------------------
+ (NSArray *)list {
    
    
    ZDChordType *st1 = [[ZDChordType alloc] initWithID:[NSNumber numberWithInt:1] andType:@"Major" andTypeShort:@""];
    ZDChordType *st2 = [[ZDChordType alloc] initWithID:[NSNumber numberWithInt:2] andType:@"Minor" andTypeShort:@"m"];
    ZDChordType *st3 = [[ZDChordType alloc] initWithID:[NSNumber numberWithInt:3] andType:@"Augmented" andTypeShort:@"+"];
    ZDChordType *st4 = [[ZDChordType alloc] initWithID:[NSNumber numberWithInt:4] andType:@"Diminiush" andTypeShort:@"dim"];
    ZDChordType *st5 = [[ZDChordType alloc] initWithID:[NSNumber numberWithInt:5] andType:@"MajorSeventh" andTypeShort:@"maj7"];
    ZDChordType *st6 = [[ZDChordType alloc] initWithID:[NSNumber numberWithInt:6] andType:@"MinorSeventh" andTypeShort:@"m7"];
    ZDChordType *st7 = [[ZDChordType alloc] initWithID:[NSNumber numberWithInt:7] andType:@"DominantSeventh" andTypeShort:@"7"];
    ZDChordType *st8 = [[ZDChordType alloc] initWithID:[NSNumber numberWithInt:8] andType:@"HalfDiminishedSeventh" andTypeShort:@"m7(b5)"];
    ZDChordType *st9 = [[ZDChordType alloc] initWithID:[NSNumber numberWithInt:9] andType:@"DiminishedSeventh" andTypeShort:@"dim7"];
    ZDChordType *st10 = [[ZDChordType alloc] initWithID:[NSNumber numberWithInt:10] andType:@"MinorMajorSeventh" andTypeShort:@"m/maj7"];
    ZDChordType *st11 = [[ZDChordType alloc] initWithID:[NSNumber numberWithInt:11] andType:@"AugmentedMajorSeventh" andTypeShort:@"+maj7"];
    
    
    NSArray *theArray = [[NSArray alloc] initWithObjects:st1, st2, st3, st4, st5, st6, st7, st8, st9, st10, st11, nil];
    
    return theArray;
}

+ (ZDChordType *)instanceWithID:(NSNumber *)theID {

    ZDChordType *result = nil;
    
    for (ZDChordType *x in [ZDChordType list]) {
        
        if ([[x typeID] intValue] == [theID intValue]) {
            
            result = x;
        }
    }
    
    return result;
}



//---------------------------------------------------------------------------------------
//---------------------------------------------------------------------------------------
#pragma mark - Constructor
//---------------------------------------------------------------------------------------
- (instancetype)initWithID:(NSNumber *)typeID andType:(NSString *)type andTypeShort:(NSString *)typeShort {

    self = [super init];
    if (self) {
        _typeID = typeID;
        _type = [type copy];
        _typeShort = [typeShort copy];
    }
    return self;
}



//---------------------------------------------------------------------------------------
//---------------------------------------------------------------------------------------
#pragma mark - Override
//---------------------------------------------------------------------------------------
- (BOOL)isEqual:(id)object {
    
    BOOL result = NO;
    
    
    if ([object isKindOfClass:[ZDChordType class]]) {
        
        ZDChordType *x = (ZDChordType *)object;
        
        if ([[x type] isEqualToString:[self type]]) {
            
            result = YES;
        }
    }
    
    return result;
    
}

@end
