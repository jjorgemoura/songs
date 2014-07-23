//
//  UINavigationItem+MultipleButtonsAddition.h
//  songs
//
//  Created by Jorge Moura on 22/07/14.
//  Copyright (c) 2014 Jorge Moura. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UINavigationItem (MultipleButtonsAddition)

@property (nonatomic, strong) IBOutletCollection(UIBarButtonItem) NSArray *rightBarButtonItemsCollection;
@property (nonatomic, strong) IBOutletCollection(UIBarButtonItem) NSArray *leftBarButtonItemsCollection;


@end
