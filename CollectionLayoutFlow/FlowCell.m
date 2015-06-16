//
//  FlowCell.m
//  CollectionLayoutFlow
//
//  Created by Zian Chen on 6/16/15.
//  Copyright (c) 2015 Zian Chen. All rights reserved.
//

#import "FlowCell.h"

@implementation FlowCell

- (void)configureWithInt:(NSInteger)value {
    self.itemLabel.text = [@(value) stringValue];
}

@end
