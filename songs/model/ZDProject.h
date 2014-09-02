//
//  ZDProject.h
//  songs
//
//  Created by Jorge Moura on 01/09/14.
//  Copyright (c) 2014 Jorge Moura. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class ZDBar;

@interface ZDProject : NSManagedObject

@property (nonatomic, retain) NSString * band;
@property (nonatomic, retain) NSNumber * bpm;
@property (nonatomic, retain) NSString * composer;
@property (nonatomic, retain) NSDate * createDate;
@property (nonatomic, retain) NSNumber * createOn;
@property (nonatomic, retain) NSString * key;
@property (nonatomic, retain) NSString * lyricsBy;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSNumber * year;
@property (nonatomic, retain) NSOrderedSet *bars;
@end

@interface ZDProject (CoreDataGeneratedAccessors)

- (void)insertObject:(ZDBar *)value inBarsAtIndex:(NSUInteger)idx;
- (void)removeObjectFromBarsAtIndex:(NSUInteger)idx;
- (void)insertBars:(NSArray *)value atIndexes:(NSIndexSet *)indexes;
- (void)removeBarsAtIndexes:(NSIndexSet *)indexes;
- (void)replaceObjectInBarsAtIndex:(NSUInteger)idx withObject:(ZDBar *)value;
- (void)replaceBarsAtIndexes:(NSIndexSet *)indexes withBars:(NSArray *)values;
- (void)addBarsObject:(ZDBar *)value;
- (void)removeBarsObject:(ZDBar *)value;
- (void)addBars:(NSOrderedSet *)values;
- (void)removeBars:(NSOrderedSet *)values;
@end
