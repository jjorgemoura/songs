//
//  NSManagedObjectID+ZDString.m
//  songs
//
//  Created by Jorge Moura on 11/07/14.
//  Copyright (c) 2014 Jorge Moura. All rights reserved.
//

#import "NSManagedObjectID+ZDString.h"

@implementation NSManagedObjectID (ZDString)

//---------------------------------------------------------------------------------------
//---------------------------------------------------------------------------------------
#pragma mark - Public Methods
//---------------------------------------------------------------------------------------
- (NSString *)stringRepresentation {

    return [[self URIRepresentation] absoluteString];
}

@end
