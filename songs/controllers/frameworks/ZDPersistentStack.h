//
//  ZDPersistentStack.h
//  songs
//
//  Created by Jorge Moura on 09/07/14.
//  Copyright (c) 2014 Jorge Moura. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface ZDPersistentStack : NSObject

@property (nonatomic, strong, readonly) NSManagedObjectContext *managedObjectContext;

- (instancetype)initWithStoreURL:(NSURL *)storeURL modelURL:(NSURL *)modelURL;

@end
