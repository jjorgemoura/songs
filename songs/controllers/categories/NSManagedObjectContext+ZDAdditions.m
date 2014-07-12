//
//  NSManagedObjectContext+ZDAdditions.m
//  songs
//
//  Created by Jorge Moura on 11/07/14.
//  Copyright (c) 2014 Jorge Moura. All rights reserved.
//

#import "NSManagedObjectContext+ZDAdditions.h"

@implementation NSManagedObjectContext (ZDAdditions)

- (NSArray *)objectsWithObjectIDs:(NSArray *)objectIDs {

    if (!objectIDs || objectIDs.count == 0) {
        return nil;
    }
    
    __block NSMutableArray *objects = [[NSMutableArray alloc] initWithCapacity:objectIDs.count];
    
    
    [self performBlockAndWait:^{
        for (NSManagedObjectID *objectID in objectIDs) {
            if ([objectID isKindOfClass:[NSNull class]]) {
                continue;
            }
            
            [objects addObject:[self objectWithID:objectID]];
        }
    }];
    
    return objects.copy;
}

@end
