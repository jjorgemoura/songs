//
//  ZDSongCollectionViewCell.h
//  songs
//
//  Created by Jorge Moura on 06/07/14.
//  Copyright (c) 2014 Jorge Moura. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZDSongCollectionViewCell : UICollectionViewCell

- (void)mainText:(NSString *)text;
- (void)auxText:(NSString *)text;
- (void)songBlock:(NSString *)songBlock;
- (void)color:(UIColor *)color;
- (void)borderColor:(UIColor *)color;
- (void)orderNumber:(NSNumber *)order;

@end
