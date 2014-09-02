//
//  ZDBar.h
//  songs
//
//  Created by Jorge Moura on 01/09/14.
//  Copyright (c) 2014 Jorge Moura. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class ZDProject, ZDSongBlock;

@interface ZDBar : NSManagedObject

@property (nonatomic, retain) NSNumber * chordType;
@property (nonatomic, retain) NSNumber * order;
@property (nonatomic, retain) NSNumber * songBlock;
@property (nonatomic, retain) NSNumber * timeSignatureBeatCount;
@property (nonatomic, retain) NSNumber * timeSignatureNoteValue;
@property (nonatomic, retain) NSNumber * chordNote;
@property (nonatomic, retain) ZDProject *theProject;
@property (nonatomic, retain) ZDSongBlock *theSongBlock;

@end
