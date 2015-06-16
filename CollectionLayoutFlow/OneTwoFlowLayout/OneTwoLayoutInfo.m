//
//  OneTwoLayoutInfo.m
//  CollectionLayoutFlow
//
//  Created by Zian Chen on 6/16/15.
//  Copyright (c) 2015 Zian Chen. All rights reserved.
//

#import "OneTwoLayoutInfo.h"

@implementation OneTwoLayoutInfo

- (id)initWithIndexPath:(NSIndexPath *)indexPath frame:(CGRect)frame {
    self = [super init];
    if (self) {
        _indexPath = indexPath;
        _frame = frame;
    }
    return self;
}


@end
