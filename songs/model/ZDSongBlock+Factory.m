//
//  ZDSongBlock+Factory.m
//  songs
//
//  Created by Jorge Moura on 09/07/14.
//  Copyright (c) 2014 Jorge Moura. All rights reserved.
//

#import "ZDSongBlock+Factory.h"

@implementation ZDSongBlock (Factory)

//---------------------------------------------------------------------------------------
//---------------------------------------------------------------------------------------
#pragma mark - Public Methods
//---------------------------------------------------------------------------------------
+ (NSString *)entityName {
    
    return NSStringFromClass([ZDSongBlock class]);
}


+ (void)preFillDatabase:(NSManagedObjectContext *)context {

    
    
    ZDSongBlock *newSongBlock1 = [NSEntityDescription insertNewObjectForEntityForName:[self entityName] inManagedObjectContext:context];
    [newSongBlock1 setColor:@"gray"];
    [newSongBlock1 setInfo:@"Intro"];
    [newSongBlock1 setName:@"intro"];
    
    ZDSongBlock *newSongBlock2 = [NSEntityDescription insertNewObjectForEntityForName:[self entityName] inManagedObjectContext:context];
    [newSongBlock2 setColor:@"green"];
    [newSongBlock2 setInfo:@"Verse"];
    [newSongBlock2 setName:@"verse"];
    
    ZDSongBlock *newSongBlock3 = [NSEntityDescription insertNewObjectForEntityForName:[self entityName] inManagedObjectContext:context];
    [newSongBlock3 setColor:@"blue"];
    [newSongBlock3 setInfo:@"Chorus"];
    [newSongBlock3 setName:@"chorus"];
    
    ZDSongBlock *newSongBlock4 = [NSEntityDescription insertNewObjectForEntityForName:[self entityName] inManagedObjectContext:context];
    [newSongBlock4 setColor:@"yellow"];
    [newSongBlock4 setInfo:@"Bridge"];
    [newSongBlock4 setName:@"bridge"];
    
    ZDSongBlock *newSongBlock5 = [NSEntityDescription insertNewObjectForEntityForName:[self entityName] inManagedObjectContext:context];
    [newSongBlock5 setColor:@"brown"];
    [newSongBlock5 setInfo:@"Hook"];
    [newSongBlock5 setName:@"hook"];
    
    ZDSongBlock *newSongBlock6 = [NSEntityDescription insertNewObjectForEntityForName:[self entityName] inManagedObjectContext:context];
    [newSongBlock6 setColor:@"red"];
    [newSongBlock6 setInfo:@"Solo"];
    [newSongBlock6 setName:@"solo"];
    
    ZDSongBlock *newSongBlock7 = [NSEntityDescription insertNewObjectForEntityForName:[self entityName] inManagedObjectContext:context];
    [newSongBlock7 setColor:@"cyan"];
    [newSongBlock7 setInfo:@"Jam"];
    [newSongBlock7 setName:@"jam"];
    
    ZDSongBlock *newSongBlock8 = [NSEntityDescription insertNewObjectForEntityForName:[self entityName] inManagedObjectContext:context];
    [newSongBlock8 setColor:@"orange"];
    [newSongBlock8 setInfo:@"Verse B"];
    [newSongBlock8 setName:@"verse_b"];
    
    ZDSongBlock *newSongBlock9 = [NSEntityDescription insertNewObjectForEntityForName:[self entityName] inManagedObjectContext:context];
    [newSongBlock9 setColor:@"pink"];
    [newSongBlock9 setInfo:@"Chorus B"];
    [newSongBlock9 setName:@"chorus_b"];
    
    ZDSongBlock *newSongBlock10 = [NSEntityDescription insertNewObjectForEntityForName:[self entityName] inManagedObjectContext:context];
    [newSongBlock10 setColor:@"cyan"];
    [newSongBlock10 setInfo:@"Break"];
    [newSongBlock10 setName:@"break"];
    
    ZDSongBlock *newSongBlock11 = [NSEntityDescription insertNewObjectForEntityForName:[self entityName] inManagedObjectContext:context];
    [newSongBlock11 setColor:@"orange"];
    [newSongBlock11 setInfo:@"Outro"];
    [newSongBlock11 setName:@"outro"];
    
    ZDSongBlock *newSongBlock12 = [NSEntityDescription insertNewObjectForEntityForName:[self entityName] inManagedObjectContext:context];
    [newSongBlock12 setColor:@"pink"];
    [newSongBlock12 setInfo:@"Coda"];
    [newSongBlock12 setName:@"coda"];

    
    
    NSError *error = nil;
    [context save:&error];
    if (error) {
        NSLog(@"CORE DATA: Error Saving SongBlock: %@", error);
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
}

+ (void (^)(void))prefillDatabaseBlock:(NSManagedObjectContext *)moc {

    return ^(void) {

        ZDSongBlock *newSongBlock1 = [NSEntityDescription insertNewObjectForEntityForName:[self entityName] inManagedObjectContext:moc];
        [newSongBlock1 setColor:@"gray"];
        [newSongBlock1 setInfo:@"Intro"];
        [newSongBlock1 setName:@"intro"];
        
        ZDSongBlock *newSongBlock2 = [NSEntityDescription insertNewObjectForEntityForName:[self entityName] inManagedObjectContext:moc];
        [newSongBlock2 setColor:@"green"];
        [newSongBlock2 setInfo:@"Verse"];
        [newSongBlock2 setName:@"verse"];
        
        ZDSongBlock *newSongBlock3 = [NSEntityDescription insertNewObjectForEntityForName:[self entityName] inManagedObjectContext:moc];
        [newSongBlock3 setColor:@"blue"];
        [newSongBlock3 setInfo:@"Chorus"];
        [newSongBlock3 setName:@"chorus"];
        
        ZDSongBlock *newSongBlock4 = [NSEntityDescription insertNewObjectForEntityForName:[self entityName] inManagedObjectContext:moc];
        [newSongBlock4 setColor:@"yellow"];
        [newSongBlock4 setInfo:@"Bridge"];
        [newSongBlock4 setName:@"bridge"];
        
        ZDSongBlock *newSongBlock5 = [NSEntityDescription insertNewObjectForEntityForName:[self entityName] inManagedObjectContext:moc];
        [newSongBlock5 setColor:@"brown"];
        [newSongBlock5 setInfo:@"Hook"];
        [newSongBlock5 setName:@"hook"];
        
        ZDSongBlock *newSongBlock6 = [NSEntityDescription insertNewObjectForEntityForName:[self entityName] inManagedObjectContext:moc];
        [newSongBlock6 setColor:@"red"];
        [newSongBlock6 setInfo:@"Solo"];
        [newSongBlock6 setName:@"solo"];
        
        ZDSongBlock *newSongBlock7 = [NSEntityDescription insertNewObjectForEntityForName:[self entityName] inManagedObjectContext:moc];
        [newSongBlock7 setColor:@"cyan"];
        [newSongBlock7 setInfo:@"Jam"];
        [newSongBlock7 setName:@"jam"];
        
        ZDSongBlock *newSongBlock8 = [NSEntityDescription insertNewObjectForEntityForName:[self entityName] inManagedObjectContext:moc];
        [newSongBlock8 setColor:@"orange"];
        [newSongBlock8 setInfo:@"Verse B"];
        [newSongBlock8 setName:@"verse_b"];
        
        ZDSongBlock *newSongBlock9 = [NSEntityDescription insertNewObjectForEntityForName:[self entityName] inManagedObjectContext:moc];
        [newSongBlock9 setColor:@"pink"];
        [newSongBlock9 setInfo:@"Chorus B"];
        [newSongBlock9 setName:@"chorus_b"];
        
        ZDSongBlock *newSongBlock10 = [NSEntityDescription insertNewObjectForEntityForName:[self entityName] inManagedObjectContext:moc];
        [newSongBlock10 setColor:@"cyan"];
        [newSongBlock10 setInfo:@"Break"];
        [newSongBlock10 setName:@"break"];
        
        ZDSongBlock *newSongBlock11 = [NSEntityDescription insertNewObjectForEntityForName:[self entityName] inManagedObjectContext:moc];
        [newSongBlock11 setColor:@"orange"];
        [newSongBlock11 setInfo:@"Outro"];
        [newSongBlock11 setName:@"outro"];
        
        ZDSongBlock *newSongBlock12 = [NSEntityDescription insertNewObjectForEntityForName:[self entityName] inManagedObjectContext:moc];
        [newSongBlock12 setColor:@"pink"];
        [newSongBlock12 setInfo:@"Coda"];
        [newSongBlock12 setName:@"coda"];
        
        NSError *error = nil;
        [moc save:&error];
        
        if(error) {
            NSLog(@"CORE DATA ERROR: Saving Song Block Factory: %@", [error debugDescription]);
        }
        
    };
}



+ (BOOL)deleteAllFromDatabase:(NSManagedObjectContext *)context {

    
    

    return NO;
}

+ (NSFetchRequest *)allEntities {

    NSFetchRequest* request = [NSFetchRequest fetchRequestWithEntityName:[self entityName]];
    //request setPredicate:[NSPredicate predicateWithFormat:@"name = "]
    
    return request;
}

+ (NSNumber *)qtEntities:(NSManagedObjectContext *)moc withError:(NSError **)error {

    NSNumber *result = nil;
    
    
    NSFetchRequest *fetchRequest = [ZDSongBlock allEntities];
    NSEntityDescription *entity = [NSEntityDescription entityForName:[ZDSongBlock entityName] inManagedObjectContext:moc];
    [fetchRequest setEntity:entity];
    
    //NSArray *fetchedObjects = [moc executeFetchRequest:fetchRequest error:error];
    //result = [NSNumber numberWithInt:[fetchedObjects count]];
    
    NSUInteger count = [moc countForFetchRequest:fetchRequest error:error];
    result = [NSNumber numberWithUnsignedInteger:count];
    
    //in case of being nil
    if(!result) {
        
        result = [NSNumber numberWithInt:0];
    }
    
    return result;
}


+ (NSNumber *)countEntities:(NSManagedObjectContext *)moc withError:(NSError **)error {
    
    NSNumber *result = nil;
    
    
    __block unsigned long intResult = 0;
    
    [moc performBlockAndWait:^{
     
        NSFetchRequest *fetchRequest = [ZDSongBlock allEntities];
        NSEntityDescription *entity = [NSEntityDescription entityForName:[ZDSongBlock entityName] inManagedObjectContext:moc];
        [fetchRequest setEntity:entity];
                               
        
        intResult = [moc countForFetchRequest:fetchRequest error:error];
    }];
    
    
    result = [NSNumber numberWithUnsignedLong:intResult];
    
    return result;
}


@end

