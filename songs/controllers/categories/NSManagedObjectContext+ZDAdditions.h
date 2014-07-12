//
//  NSManagedObjectContext+ZDAdditions.h
//  songs
//
//  Created by Jorge Moura on 11/07/14.
//  Copyright (c) 2014 Jorge Moura. All rights reserved.
//

#import <CoreData/CoreData.h>

@interface NSManagedObjectContext (ZDAdditions)

- (NSArray *)objectsWithObjectIDs:(NSArray *)objectIDs;

@end
