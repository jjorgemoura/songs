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
//+ (void (^)(NSManagedObjectContext *))prefillDatabaseBlock;
+ (void (^)(void))prefillDatabaseBlock:(NSManagedObjectContext *)moc;

+ (BOOL)deleteAllFromDatabase:(NSManagedObjectContext *)context;

+ (NSFetchRequest *)allEntities;
+ (NSNumber *)qtEntities:(NSManagedObjectContext *)moc withError:(NSError **)error;
+ (NSNumber *)countEntities:(NSManagedObjectContext *)moc withError:(NSError **)error;

@end
