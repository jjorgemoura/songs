//
//  ZDSongBlock+Factory.h
//  songs
//
//  Created by Jorge Moura on 09/07/14.
//  Copyright (c) 2014 Jorge Moura. All rights reserved.
//

#import "ZDSongBlock.h"

@interface ZDSongBlock (Factory)

+ (NSString *)entityName;
+ (void)preFillDatabase:(NSManagedObjectContext *)context;
+ (BOOL)deleteAllFromDatabase:(NSManagedObjectContext *)context;
+ (NSFetchRequest *)allEntities;

@end
