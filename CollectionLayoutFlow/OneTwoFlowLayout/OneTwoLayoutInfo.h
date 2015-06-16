//
//  OneTwoLayoutInfo.h
//  CollectionLayoutFlow
//
//  Created by Zian Chen on 6/16/15.
//  Copyright (c) 2015 Zian Chen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OneTwoLayoutInfo : NSObject
@property (nonatomic, strong) NSIndexPath *indexPath;
@property (nonatomic, assign) CGRect frame;

- (id)initWithIndexPath:(NSIndexPath *)indexPath frame:(CGRect)frame;

@end
