//
//  ZDBar+Factory.h
//  songs
//
//  Created by Jorge Moura on 09/07/14.
//  Copyright (c) 2014 Jorge Moura. All rights reserved.
//

#import "ZDBar.h"

@interface ZDBar (Factory)


+ (NSString *)entityName;

+ (NSArray *)defaultBars:(NSManagedObjectContext *)moc;


@end
