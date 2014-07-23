//
//  UINavigationItem+MultipleButtonsAddition.m
//  songs
//
//  Created by Jorge Moura on 22/07/14.
//  Copyright (c) 2014 Jorge Moura. All rights reserved.
//

#import "UINavigationItem+MultipleButtonsAddition.h"

@implementation UINavigationItem (MultipleButtonsAddition)

- (void)setRightBarButtonItemsCollection:(NSArray *)rightBarButtonItemsCollection {
    self.rightBarButtonItems = [rightBarButtonItemsCollection sortedArrayUsingDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"tag" ascending:YES]]];
}

- (void)setLeftBarButtonItemsCollection:(NSArray *)leftBarButtonItemsCollection {
    self.leftBarButtonItems = [leftBarButtonItemsCollection sortedArrayUsingDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"tag" ascending:YES]]];
}

- (NSArray *)rightBarButtonItemsCollection {
    return self.rightBarButtonItems;
}

- (NSArray *)leftBarButtonItemsCollection {
    return self.leftBarButtonItems;
}

@end
