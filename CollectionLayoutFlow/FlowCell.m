//
//  FlowCell.m
//  CollectionLayoutFlow
//
//  Created by Zian Chen on 6/16/15.
//  Copyright (c) 2015 Zian Chen. All rights reserved.
//

#import "FlowCell.h"

@implementation FlowCell

-(void)layoutSubviews{
    [super layoutSubviews];
    
    if(self.traitCollection.horizontalSizeClass == UIUserInterfaceSizeClassRegular) {
        if(self.frame.size.width > 500){
            // Set text size for large iPad cell
            
            
        } else {
            // Set text for small iPad cell
            
        }
    } else {
        // Set Text for iPhone-like cell
        
        
    }
    
}
- (void)configureWithInt:(NSInteger)value {
    self.itemLabel.text = @"girl code";
    self.descriptionLabel.text = @"watch a sneak peak";
}

@end
