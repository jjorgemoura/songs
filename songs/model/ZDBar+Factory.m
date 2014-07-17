//
//  ZDBar+Factory.m
//  songs
//
//  Created by Jorge Moura on 09/07/14.
//  Copyright (c) 2014 Jorge Moura. All rights reserved.
//

#import "ZDBar+Factory.h"
#import "ZDSongBlock+Factory.h"

@implementation ZDBar (Factory)


//---------------------------------------------------------------------------------------
//---------------------------------------------------------------------------------------
#pragma mark - Public Methods
//---------------------------------------------------------------------------------------
+ (NSString *)entityName {
    
    return NSStringFromClass([ZDBar class]);
}

+ (NSArray *)defaultBars:(NSManagedObjectContext *)moc {

    NSArray *theSet;
    
    ZDSongBlock *songBlockIntro = [ZDSongBlock objectWithName:@"intro" inContext:moc];
    ZDSongBlock *songBlockVerse = [ZDSongBlock objectWithName:@"verse" inContext:moc];
    ZDSongBlock *songBlockChorus = [ZDSongBlock objectWithName:@"chorus" inContext:moc];
    ZDSongBlock *songBlockBreak = [ZDSongBlock objectWithName:@"break" inContext:moc];
    
    ZDBar *newBar1 = [NSEntityDescription insertNewObjectForEntityForName:[ZDBar entityName] inManagedObjectContext:moc];
    [newBar1 setChordType:@"C"];
    [newBar1 setOrder:[NSNumber numberWithInt:1]];
    [newBar1 setSongBlock:[NSNumber numberWithInt:1]];
    [newBar1 setTimeSignatureBeatCount:[NSNumber numberWithInt:4]];
    [newBar1 setTimeSignatureNoteValue:[NSNumber numberWithInt:4]];
    [newBar1 setTheSongBlock:songBlockIntro];
    
    ZDBar *newBar2 = [NSEntityDescription insertNewObjectForEntityForName:[ZDBar entityName] inManagedObjectContext:moc];
    [newBar2 setChordType:@"C"];
    [newBar2 setOrder:[NSNumber numberWithInt:2]];
    [newBar2 setSongBlock:[NSNumber numberWithInt:1]];
    [newBar2 setTimeSignatureBeatCount:[NSNumber numberWithInt:4]];
    [newBar2 setTimeSignatureNoteValue:[NSNumber numberWithInt:4]];
    [newBar2 setTheSongBlock:songBlockIntro];
    
    ZDBar *newBar3 = [NSEntityDescription insertNewObjectForEntityForName:[ZDBar entityName] inManagedObjectContext:moc];
    [newBar3 setChordType:@"A"];
    [newBar3 setOrder:[NSNumber numberWithInt:3]];
    [newBar3 setSongBlock:[NSNumber numberWithInt:1]];
    [newBar3 setTimeSignatureBeatCount:[NSNumber numberWithInt:4]];
    [newBar3 setTimeSignatureNoteValue:[NSNumber numberWithInt:4]];
    [newBar3 setTheSongBlock:songBlockIntro];
    
    ZDBar *newBar4 = [NSEntityDescription insertNewObjectForEntityForName:[ZDBar entityName] inManagedObjectContext:moc];
    [newBar4 setChordType:@"A"];
    [newBar4 setOrder:[NSNumber numberWithInt:4]];
    [newBar4 setSongBlock:[NSNumber numberWithInt:1]];
    [newBar4 setTimeSignatureBeatCount:[NSNumber numberWithInt:4]];
    [newBar4 setTimeSignatureNoteValue:[NSNumber numberWithInt:4]];
    [newBar4 setTheSongBlock:songBlockIntro];
    
    ZDBar *newBar5 = [NSEntityDescription insertNewObjectForEntityForName:[ZDBar entityName] inManagedObjectContext:moc];
    [newBar5 setChordType:@"C"];
    [newBar5 setOrder:[NSNumber numberWithInt:5]];
    [newBar5 setSongBlock:[NSNumber numberWithInt:1]];
    [newBar5 setTimeSignatureBeatCount:[NSNumber numberWithInt:4]];
    [newBar5 setTimeSignatureNoteValue:[NSNumber numberWithInt:4]];
    [newBar5 setTheSongBlock:songBlockVerse];
    
    ZDBar *newBar6 = [NSEntityDescription insertNewObjectForEntityForName:[ZDBar entityName] inManagedObjectContext:moc];
    [newBar6 setChordType:@"G"];
    [newBar6 setOrder:[NSNumber numberWithInt:6]];
    [newBar6 setSongBlock:[NSNumber numberWithInt:1]];
    [newBar6 setTimeSignatureBeatCount:[NSNumber numberWithInt:4]];
    [newBar6 setTimeSignatureNoteValue:[NSNumber numberWithInt:4]];
    [newBar6 setTheSongBlock:songBlockVerse];
    
    ZDBar *newBar7 = [NSEntityDescription insertNewObjectForEntityForName:[ZDBar entityName] inManagedObjectContext:moc];
    [newBar7 setChordType:@"C"];
    [newBar7 setOrder:[NSNumber numberWithInt:7]];
    [newBar7 setSongBlock:[NSNumber numberWithInt:1]];
    [newBar7 setTimeSignatureBeatCount:[NSNumber numberWithInt:4]];
    [newBar7 setTimeSignatureNoteValue:[NSNumber numberWithInt:4]];
    [newBar7 setTheSongBlock:songBlockVerse];
    
    ZDBar *newBar8 = [NSEntityDescription insertNewObjectForEntityForName:[ZDBar entityName] inManagedObjectContext:moc];
    [newBar8 setChordType:@"G"];
    [newBar8 setOrder:[NSNumber numberWithInt:8]];
    [newBar8 setSongBlock:[NSNumber numberWithInt:1]];
    [newBar8 setTimeSignatureBeatCount:[NSNumber numberWithInt:4]];
    [newBar8 setTimeSignatureNoteValue:[NSNumber numberWithInt:4]];
    [newBar8 setTheSongBlock:songBlockVerse];
    
    ZDBar *newBar9 = [NSEntityDescription insertNewObjectForEntityForName:[ZDBar entityName] inManagedObjectContext:moc];
    [newBar9 setChordType:@"Em"];
    [newBar9 setOrder:[NSNumber numberWithInt:9]];
    [newBar9 setSongBlock:[NSNumber numberWithInt:1]];
    [newBar9 setTimeSignatureBeatCount:[NSNumber numberWithInt:4]];
    [newBar9 setTimeSignatureNoteValue:[NSNumber numberWithInt:4]];
    [newBar9 setTheSongBlock:songBlockBreak];
    
    ZDBar *newBar10 = [NSEntityDescription insertNewObjectForEntityForName:[ZDBar entityName] inManagedObjectContext:moc];
    [newBar10 setChordType:@"Em"];
    [newBar10 setOrder:[NSNumber numberWithInt:10]];
    [newBar10 setSongBlock:[NSNumber numberWithInt:1]];
    [newBar10 setTimeSignatureBeatCount:[NSNumber numberWithInt:4]];
    [newBar10 setTimeSignatureNoteValue:[NSNumber numberWithInt:4]];
    [newBar10 setTheSongBlock:songBlockBreak];
    
    ZDBar *newBar11 = [NSEntityDescription insertNewObjectForEntityForName:[ZDBar entityName] inManagedObjectContext:moc];
    [newBar11 setChordType:@"C"];
    [newBar11 setOrder:[NSNumber numberWithInt:11]];
    [newBar11 setSongBlock:[NSNumber numberWithInt:1]];
    [newBar11 setTimeSignatureBeatCount:[NSNumber numberWithInt:4]];
    [newBar11 setTimeSignatureNoteValue:[NSNumber numberWithInt:4]];
    [newBar11 setTheSongBlock:songBlockVerse];
    
    ZDBar *newBar12 = [NSEntityDescription insertNewObjectForEntityForName:[ZDBar entityName] inManagedObjectContext:moc];
    [newBar12 setChordType:@"G"];
    [newBar12 setOrder:[NSNumber numberWithInt:12]];
    [newBar12 setSongBlock:[NSNumber numberWithInt:1]];
    [newBar12 setTimeSignatureBeatCount:[NSNumber numberWithInt:4]];
    [newBar12 setTimeSignatureNoteValue:[NSNumber numberWithInt:4]];
    [newBar12 setTheSongBlock:songBlockVerse];
    
    ZDBar *newBar13 = [NSEntityDescription insertNewObjectForEntityForName:[ZDBar entityName] inManagedObjectContext:moc];
    [newBar13 setChordType:@"C"];
    [newBar13 setOrder:[NSNumber numberWithInt:13]];
    [newBar13 setSongBlock:[NSNumber numberWithInt:1]];
    [newBar13 setTimeSignatureBeatCount:[NSNumber numberWithInt:4]];
    [newBar13 setTimeSignatureNoteValue:[NSNumber numberWithInt:4]];
    [newBar13 setTheSongBlock:songBlockVerse];
    
    ZDBar *newBar14 = [NSEntityDescription insertNewObjectForEntityForName:[ZDBar entityName] inManagedObjectContext:moc];
    [newBar14 setChordType:@"G"];
    [newBar14 setOrder:[NSNumber numberWithInt:14]];
    [newBar14 setSongBlock:[NSNumber numberWithInt:1]];
    [newBar14 setTimeSignatureBeatCount:[NSNumber numberWithInt:4]];
    [newBar14 setTimeSignatureNoteValue:[NSNumber numberWithInt:4]];
    [newBar14 setTheSongBlock:songBlockVerse];
    
    ZDBar *newBar15 = [NSEntityDescription insertNewObjectForEntityForName:[ZDBar entityName] inManagedObjectContext:moc];
    [newBar15 setChordType:@"G"];
    [newBar15 setOrder:[NSNumber numberWithInt:15]];
    [newBar15 setSongBlock:[NSNumber numberWithInt:1]];
    [newBar15 setTimeSignatureBeatCount:[NSNumber numberWithInt:4]];
    [newBar15 setTimeSignatureNoteValue:[NSNumber numberWithInt:4]];
    [newBar15 setTheSongBlock:songBlockChorus];
    
    ZDBar *newBar16 = [NSEntityDescription insertNewObjectForEntityForName:[ZDBar entityName] inManagedObjectContext:moc];
    [newBar16 setChordType:@"F"];
    [newBar16 setOrder:[NSNumber numberWithInt:16]];
    [newBar16 setSongBlock:[NSNumber numberWithInt:1]];
    [newBar16 setTimeSignatureBeatCount:[NSNumber numberWithInt:4]];
    [newBar16 setTimeSignatureNoteValue:[NSNumber numberWithInt:4]];
    [newBar16 setTheSongBlock:songBlockChorus];
    
    ZDBar *newBar17 = [NSEntityDescription insertNewObjectForEntityForName:[ZDBar entityName] inManagedObjectContext:moc];
    [newBar17 setChordType:@"G"];
    [newBar17 setOrder:[NSNumber numberWithInt:17]];
    [newBar17 setSongBlock:[NSNumber numberWithInt:1]];
    [newBar17 setTimeSignatureBeatCount:[NSNumber numberWithInt:4]];
    [newBar17 setTimeSignatureNoteValue:[NSNumber numberWithInt:4]];
    [newBar17 setTheSongBlock:songBlockChorus];
    
    ZDBar *newBar18 = [NSEntityDescription insertNewObjectForEntityForName:[ZDBar entityName] inManagedObjectContext:moc];
    [newBar18 setChordType:@"F"];
    [newBar18 setOrder:[NSNumber numberWithInt:18]];
    [newBar18 setSongBlock:[NSNumber numberWithInt:1]];
    [newBar18 setTimeSignatureBeatCount:[NSNumber numberWithInt:4]];
    [newBar18 setTimeSignatureNoteValue:[NSNumber numberWithInt:4]];
    [newBar18 setTheSongBlock:songBlockChorus];
    
    ZDBar *newBar19 = [NSEntityDescription insertNewObjectForEntityForName:[ZDBar entityName] inManagedObjectContext:moc];
    [newBar19 setChordType:@"Em"];
    [newBar19 setOrder:[NSNumber numberWithInt:19]];
    [newBar19 setSongBlock:[NSNumber numberWithInt:1]];
    [newBar19 setTimeSignatureBeatCount:[NSNumber numberWithInt:4]];
    [newBar19 setTimeSignatureNoteValue:[NSNumber numberWithInt:4]];
    [newBar19 setTheSongBlock:songBlockBreak];
    
    ZDBar *newBar20 = [NSEntityDescription insertNewObjectForEntityForName:[ZDBar entityName] inManagedObjectContext:moc];
    [newBar20 setChordType:@"Em"];
    [newBar20 setOrder:[NSNumber numberWithInt:20]];
    [newBar20 setSongBlock:[NSNumber numberWithInt:1]];
    [newBar20 setTimeSignatureBeatCount:[NSNumber numberWithInt:4]];
    [newBar20 setTimeSignatureNoteValue:[NSNumber numberWithInt:4]];
    [newBar20 setTheSongBlock:songBlockBreak];
    
    theSet = [NSArray arrayWithObjects:newBar1, newBar2, newBar3, newBar4, newBar5, newBar6, newBar7, newBar8, newBar9, newBar10,
              newBar11, newBar12, newBar13, newBar14, newBar15, newBar16, newBar17, newBar18, newBar19, newBar20, nil];
    
    
    return theSet;
}


@end
