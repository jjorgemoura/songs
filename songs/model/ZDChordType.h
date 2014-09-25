//
//  ZDChordType.h
//  songs
//
//  Created by Jorge Moura on 01/09/14.
//  Copyright (c) 2014 Jorge Moura. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZDChordType : NSObject


@property (nonatomic, readonly) NSNumber *typeID;
@property (nonatomic, readonly, copy) NSString *type;
@property (nonatomic, readonly, copy) NSString *typeShort;


+ (NSArray *)list;
+ (ZDChordType *)instanceWithID:(NSNumber *)theID;

- (instancetype)initWithID:(NSNumber *)typeID andType:(NSString *)type andTypeShort:(NSString *)typeShort;

- (BOOL)isEqual:(id)object;


@end
