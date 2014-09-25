//
//  ZDNote.m
//  songs
//
//  Created by Jorge Moura on 01/09/14.
//  Copyright (c) 2014 Jorge Moura. All rights reserved.
//


#import "ZDNote.h"


@implementation ZDNote


//---------------------------------------------------------------------------------------
//---------------------------------------------------------------------------------------
#pragma mark - Class Methods
//---------------------------------------------------------------------------------------
+ (NSArray *)list {
    
    
    ZDNote *nt1 = [[ZDNote alloc] initWithNote:C];
    ZDNote *nt2 = [[ZDNote alloc] initWithNote:CSharp];
    ZDNote *nt3 = [[ZDNote alloc] initWithNote:D];
    ZDNote *nt4 = [[ZDNote alloc] initWithNote:DSharp];
    ZDNote *nt5 = [[ZDNote alloc] initWithNote:E];
    ZDNote *nt6 = [[ZDNote alloc] initWithNote:F];
    ZDNote *nt7 = [[ZDNote alloc] initWithNote:FSharp];
    ZDNote *nt8 = [[ZDNote alloc] initWithNote:G];
    ZDNote *nt9 = [[ZDNote alloc] initWithNote:GSharp];
    ZDNote *nt10 = [[ZDNote alloc] initWithNote:A];
    ZDNote *nt11 = [[ZDNote alloc] initWithNote:ASharp];
    ZDNote *nt12 = [[ZDNote alloc] initWithNote:B];
    
    NSArray *theArray = [[NSArray alloc] initWithObjects:nt1, nt2, nt3, nt4, nt5, nt6, nt7, nt8, nt9, nt10, nt11, nt12, nil];
    
    return theArray;
}


+ (ZDNote *)noteWithHalfSteps:(NSInteger)halfsteps fromNote:(ZDNote *)note {
    
    NSInteger noteStep = 0;
    
    //test of octave
    if ([note note] + halfsteps > 12) {
        
        noteStep = [note note] + halfsteps - 12;
    }
    else {
        
        noteStep = [note note] + halfsteps;
    }
    
    
    ZDMusicNote x = noteStep;
    
    ZDNote *returnNote = [[ZDNote alloc] initWithNote:x];
    
    return returnNote;
}



//---------------------------------------------------------------------------------------
//---------------------------------------------------------------------------------------
#pragma mark - Constructor
//---------------------------------------------------------------------------------------
- (instancetype)initWithNote:(ZDMusicNote)note {
    
    self = [super init];
    if (self) {
        
        _note = note;
        _musicNote = note;
        _noteText = [self noteToText:[self note]];
    }
    return self;
}


//---------------------------------------------------------------------------------------
//---------------------------------------------------------------------------------------
#pragma mark - Public Methods
//---------------------------------------------------------------------------------------
- (NSString *)description {
    
    NSString *result = [self noteToText:[self note]];
    
    return result;
}


- (NSString *)noteToText:(NSInteger)theNote
{
    NSString *description = nil;
    
    if(theNote == C) {
        description = @"C";
    }
    
    if(theNote == CSharp) {
        description = @"C#/Db";
    }
    
    if(theNote == D) {
        description = @"D";
    }
    
    if(theNote == DSharp) {
        description = @"D#/Eb";
    }
    
    if(theNote == E) {
        description = @"E";
    }
    
    if(theNote == F) {
        description = @"F";
    }
    
    if(theNote == FSharp) {
        description = @"F#/Gb";
    }
    
    if(theNote == G) {
        description = @"G";
    }
    
    if(theNote == GSharp) {
        description = @"G#/Ab";
    }
    
    if(theNote == A) {
        description = @"A";
    }
    
    if(theNote == ASharp) {
        description = @"A#/Bb";
    }
    
    if(theNote == B) {
        description = @"B";
    }
    
    
    return description;
}




//---------------------------------------------------------------------------------------
//---------------------------------------------------------------------------------------
#pragma mark - Override
//---------------------------------------------------------------------------------------
- (BOOL)isEqual:(id)object {

    BOOL result = NO;
    
    
    if ([object isKindOfClass:[ZDNote class]]) {
        
        ZDNote *x = (ZDNote *)object;
        
        if ([[x noteText] isEqualToString:[self noteText]]) {
            
            result = YES;
        }
    }

    return result;

}

@end