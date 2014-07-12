//
//  ZDCoreDataStack.h
//  songs
//
//  Created by Jorge Moura on 11/07/14.
//  Copyright (c) 2014 Jorge Moura. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZDCoreDataStack : NSObject

+ (instancetype)defaultStore;

+ (NSManagedObjectContext *)mainQueueContext;
+ (NSManagedObjectContext *)privateQueueContext;

+ (NSManagedObjectID *)managedObjectIDFromString:(NSString *)managedObjectIDString;


@end
