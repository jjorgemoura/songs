//
//  ZDSongBlock.h
//  songs
//
//  Created by Jorge Moura on 02/07/14.
//  Copyright (c) 2014 Jorge Moura. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface ZDSongBlock : NSManagedObject

@property (nonatomic, retain) NSString * color;
@property (nonatomic, retain) NSString * info;
@property (nonatomic, retain) NSString * name;

@end