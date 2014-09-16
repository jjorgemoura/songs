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
#pragma mark - Class Methods
//---------------------------------------------------------------------------------------
+ (NSString *)entityName {
    
    return NSStringFromClass([ZDSongBlock class]);
}


+ (void)preFillDatabase:(NSManagedObjectContext *)context {

//    
//    
//    ZDSongBlock *newSongBlock1 = [NSEntityDescription insertNewObjectForEntityForName:[self entityName] inManagedObjectContext:context];
//    [newSongBlock1 setColor:@"gray"];
//    [newSongBlock1 setInfo:@"Intro"];
//    [newSongBlock1 setName:@"intro"];
//    [newSongBlock1 setHexColor:@"#898C90"];
//    
//    ZDSongBlock *newSongBlock2 = [NSEntityDescription insertNewObjectForEntityForName:[self entityName] inManagedObjectContext:context];
//    [newSongBlock2 setColor:@"green"];
//    [newSongBlock2 setInfo:@"Verse"];
//    [newSongBlock2 setName:@"verse"];
//    [newSongBlock2 setHexColor:@"#0BD318"];
//    
//    ZDSongBlock *newSongBlock3 = [NSEntityDescription insertNewObjectForEntityForName:[self entityName] inManagedObjectContext:context];
//    [newSongBlock3 setColor:@"blue"];
//    [newSongBlock3 setInfo:@"Chorus"];
//    [newSongBlock3 setName:@"chorus"];
//    [newSongBlock3 setHexColor:@"#5BCAFF"];
//    
//    ZDSongBlock *newSongBlock4 = [NSEntityDescription insertNewObjectForEntityForName:[self entityName] inManagedObjectContext:context];
//    [newSongBlock4 setColor:@"yellow"];
//    [newSongBlock4 setInfo:@"Bridge"];
//    [newSongBlock4 setName:@"bridge"];
//    [newSongBlock4 setHexColor:@"#FFCC00"];
//    
//    ZDSongBlock *newSongBlock5 = [NSEntityDescription insertNewObjectForEntityForName:[self entityName] inManagedObjectContext:context];
//    [newSongBlock5 setColor:@"sea"];
//    [newSongBlock5 setInfo:@"Hook"];
//    [newSongBlock5 setName:@"hook"];
//    [newSongBlock5 setHexColor:@"#55EFCB"];
//    
//    ZDSongBlock *newSongBlock6 = [NSEntityDescription insertNewObjectForEntityForName:[self entityName] inManagedObjectContext:context];
//    [newSongBlock6 setColor:@"red"];
//    [newSongBlock6 setInfo:@"Solo"];
//    [newSongBlock6 setName:@"solo"];
//    [newSongBlock6 setHexColor:@"#FF5E3A"];
//    
//    ZDSongBlock *newSongBlock7 = [NSEntityDescription insertNewObjectForEntityForName:[self entityName] inManagedObjectContext:context];
//    [newSongBlock7 setColor:@"cyan"];
//    [newSongBlock7 setInfo:@"Jam"];
//    [newSongBlock7 setName:@"jam"];
//    [newSongBlock7 setHexColor:@"#55EFCB"];
//    
//    ZDSongBlock *newSongBlock8 = [NSEntityDescription insertNewObjectForEntityForName:[self entityName] inManagedObjectContext:context];
//    [newSongBlock8 setColor:@"orange"];
//    [newSongBlock8 setInfo:@"Verse B"];
//    [newSongBlock8 setName:@"verse_b"];
//    [newSongBlock8 setHexColor:@"#FF9500"];
//    
//    ZDSongBlock *newSongBlock9 = [NSEntityDescription insertNewObjectForEntityForName:[self entityName] inManagedObjectContext:context];
//    [newSongBlock9 setColor:@"pink"];
//    [newSongBlock9 setInfo:@"Chorus B"];
//    [newSongBlock9 setName:@"chorus_b"];
//    [newSongBlock9 setHexColor:@"#FF4981"];
//    
//    ZDSongBlock *newSongBlock10 = [NSEntityDescription insertNewObjectForEntityForName:[self entityName] inManagedObjectContext:context];
//    [newSongBlock10 setColor:@"smoke"];
//    [newSongBlock10 setInfo:@"Break"];
//    [newSongBlock10 setName:@"break"];
//    [newSongBlock10 setHexColor:@"#E0F8D8"];
//    
//    ZDSongBlock *newSongBlock11 = [NSEntityDescription insertNewObjectForEntityForName:[self entityName] inManagedObjectContext:context];
//    [newSongBlock11 setColor:@"purple"];
//    [newSongBlock11 setInfo:@"Outro"];
//    [newSongBlock11 setName:@"outro"];
//    [newSongBlock11 setHexColor:@"#EF4DB6"];
//    
//    ZDSongBlock *newSongBlock12 = [NSEntityDescription insertNewObjectForEntityForName:[self entityName] inManagedObjectContext:context];
//    [newSongBlock12 setColor:@"cream"];
//    [newSongBlock12 setInfo:@"Coda"];
//    [newSongBlock12 setName:@"coda"];
//    [newSongBlock12 setHexColor:@"#E4DDCA"];
//
//    
//    
//    NSError *error = nil;
//    [context save:&error];
//    if (error) {
//        NSLog(@"CORE DATA: Error Saving SongBlock: %@", error);
//        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
//        abort();
//    }
    
}

+ (void (^)(void))prefillDatabaseBlock:(NSManagedObjectContext *)moc {

    return ^(void) {

        ZDSongBlock *newSongBlock1 = [NSEntityDescription insertNewObjectForEntityForName:[self entityName] inManagedObjectContext:moc];
        [newSongBlock1 setColor:@"gray"];
        [newSongBlock1 setInfo:@"Intro"];
        [newSongBlock1 setName:@"intro"];
        [newSongBlock1 setHexColor:@"#C7C7CC"];
        [newSongBlock1 setBorderHexColor:@"#898c90"];
        
        ZDSongBlock *newSongBlock2 = [NSEntityDescription insertNewObjectForEntityForName:[self entityName] inManagedObjectContext:moc];
        [newSongBlock2 setColor:@"green"];
        [newSongBlock2 setInfo:@"Verse"];
        [newSongBlock2 setName:@"verse"];
        [newSongBlock2 setHexColor:@"#0BD318"];
        [newSongBlock2 setBorderHexColor:@"#898c90"];
        
        ZDSongBlock *newSongBlock3 = [NSEntityDescription insertNewObjectForEntityForName:[self entityName] inManagedObjectContext:moc];
        [newSongBlock3 setColor:@"blue"];
        [newSongBlock3 setInfo:@"Chorus"];
        [newSongBlock3 setName:@"chorus"];
        [newSongBlock3 setHexColor:@"#5BCAFF"];
        [newSongBlock3 setBorderHexColor:@"#898c90"];
        
        ZDSongBlock *newSongBlock4 = [NSEntityDescription insertNewObjectForEntityForName:[self entityName] inManagedObjectContext:moc];
        [newSongBlock4 setColor:@"yellow"];
        [newSongBlock4 setInfo:@"Bridge"];
        [newSongBlock4 setName:@"bridge"];
        [newSongBlock4 setHexColor:@"#FFCC00"];
        [newSongBlock4 setBorderHexColor:@"#898c90"];
        
        ZDSongBlock *newSongBlock5 = [NSEntityDescription insertNewObjectForEntityForName:[self entityName] inManagedObjectContext:moc];
        [newSongBlock5 setColor:@"sea"];
        [newSongBlock5 setInfo:@"Hook"];
        [newSongBlock5 setName:@"hook"];
        [newSongBlock5 setHexColor:@"#55EFCB"];
        [newSongBlock5 setBorderHexColor:@"#898c90"];
        
        ZDSongBlock *newSongBlock6 = [NSEntityDescription insertNewObjectForEntityForName:[self entityName] inManagedObjectContext:moc];
        [newSongBlock6 setColor:@"red"];
        [newSongBlock6 setInfo:@"Solo"];
        [newSongBlock6 setName:@"solo"];
        [newSongBlock6 setHexColor:@"#FF5E3A"];
        [newSongBlock6 setBorderHexColor:@"#898c90"];
        
        ZDSongBlock *newSongBlock7 = [NSEntityDescription insertNewObjectForEntityForName:[self entityName] inManagedObjectContext:moc];
        [newSongBlock7 setColor:@"cyan"];
        [newSongBlock7 setInfo:@"Jam"];
        [newSongBlock7 setName:@"jam"];
        [newSongBlock7 setHexColor:@"#55EFCB"];
        [newSongBlock7 setBorderHexColor:@"#898c90"];
        
        ZDSongBlock *newSongBlock8 = [NSEntityDescription insertNewObjectForEntityForName:[self entityName] inManagedObjectContext:moc];
        [newSongBlock8 setColor:@"orange"];
        [newSongBlock8 setInfo:@"Verse B"];
        [newSongBlock8 setName:@"verse_b"];
        [newSongBlock8 setHexColor:@"#FF9500"];
        [newSongBlock8 setBorderHexColor:@"#898c90"];
        
        ZDSongBlock *newSongBlock9 = [NSEntityDescription insertNewObjectForEntityForName:[self entityName] inManagedObjectContext:moc];
        [newSongBlock9 setColor:@"pink"];
        [newSongBlock9 setInfo:@"Chorus B"];
        [newSongBlock9 setName:@"chorus_b"];
        [newSongBlock9 setHexColor:@"#FF4981"];
        [newSongBlock9 setBorderHexColor:@"#898c90"];
        
        ZDSongBlock *newSongBlock10 = [NSEntityDescription insertNewObjectForEntityForName:[self entityName] inManagedObjectContext:moc];
        [newSongBlock10 setColor:@"smoke"];
        [newSongBlock10 setInfo:@"Break"];
        [newSongBlock10 setName:@"break"];
        [newSongBlock10 setHexColor:@"#E0F8D8"];
        [newSongBlock10 setBorderHexColor:@"#898c90"];
        
        ZDSongBlock *newSongBlock11 = [NSEntityDescription insertNewObjectForEntityForName:[self entityName] inManagedObjectContext:moc];
        [newSongBlock11 setColor:@"purple"];
        [newSongBlock11 setInfo:@"Outro"];
        [newSongBlock11 setName:@"outro"];
        [newSongBlock11 setHexColor:@"#EF4DB6"];
        [newSongBlock11 setBorderHexColor:@"#898c90"];
        
        ZDSongBlock *newSongBlock12 = [NSEntityDescription insertNewObjectForEntityForName:[self entityName] inManagedObjectContext:moc];
        [newSongBlock12 setColor:@"cream"];
        [newSongBlock12 setInfo:@"Coda"];
        [newSongBlock12 setName:@"coda"];
        [newSongBlock12 setHexColor:@"#E4DDCA"];
        [newSongBlock12 setBorderHexColor:@"#898c90"];
        
        NSError *error = nil;
        [moc save:&error];
        
        if(error) {
            NSLog(@"CORE DATA ERROR: Saving Song Block Factory: %@", [error debugDescription]);
        }
        
    };
}




+ (instancetype)objectWithName:(NSString *)name inContext:(NSManagedObjectContext *)moc {

    ZDSongBlock *x = nil;

    NSFetchRequest *fetchRequest = [ZDSongBlock allEntities];
    NSEntityDescription *entity = [NSEntityDescription entityForName:[ZDSongBlock entityName] inManagedObjectContext:moc];
    [fetchRequest setEntity:entity];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"name == %@", name];
    [fetchRequest setPredicate:predicate];
    
    NSError *error = nil;
    NSArray *result = [moc executeFetchRequest:fetchRequest error:&error];
    
    
    //in case of being nil
    if(result) {
        
        x = [result objectAtIndex:0];
    }
    else {
    
        NSLog(@"Load ZDSongBlock Entity Error: %@", error);
    }

    
    return x;
}

+ (BOOL)deleteAllFromDatabase:(NSManagedObjectContext *)context {

    
    

    return NO;
}

+ (NSFetchRequest *)allEntities {

    NSFetchRequest* request = [NSFetchRequest fetchRequestWithEntityName:[self entityName]];
    //request setPredicate:[NSPredicate predicateWithFormat:@"name = "]
    
    return request;
}

+ (NSArray *)allEntitiesNames:(NSManagedObjectContext *)moc withError:(NSError **)error {

    NSMutableArray *result = nil;
    
    NSFetchRequest *fetchRequest = [ZDSongBlock allEntities];
    NSEntityDescription *entity = [NSEntityDescription entityForName:[ZDSongBlock entityName] inManagedObjectContext:moc];
    [fetchRequest setEntity:entity];
    
    NSArray *fetchedObjects = [moc executeFetchRequest:fetchRequest error:error];
    

    
    result = [[NSMutableArray alloc] initWithCapacity:[fetchedObjects count]];
    
    //in case of being nil
    if(fetchedObjects) {
        
        for (NSManagedObject *x in fetchedObjects) {
        
            ZDSongBlock *domObj = (ZDSongBlock *)x;
            
            [result addObject:[domObj name]];
        }
    }
    
    return result;
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

