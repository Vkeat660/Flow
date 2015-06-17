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
    
    [self setupFontSize];
    [super layoutSubviews];
}

-(void)setupFontSize{
    
    if(self.traitCollection.horizontalSizeClass == UIUserInterfaceSizeClassRegular) {
        if(self.frame.size.width > 500){
            // Set text size for large iPad cell
            
            self.itemLabel.font        = [UIFont fontWithName:@"HelveticaNeueLTStd-Hv" size:50.0];
            self.descriptionLabel.font = [UIFont fontWithName:@"HelveticaNeueLTStd-Hv" size:36.0];
            
        } else {
            // Set text for small iPad cell
            
            self.itemLabel.font        = [UIFont fontWithName:@"HelveticaNeueLTStd-Hv" size:25.0];
            self.descriptionLabel.font = [UIFont fontWithName:@"HelveticaNeueLTStd-Hv" size:18.0];
            
        }
    } else {
        // Set Text for iPhone-like cell
        
        self.itemLabel.font = [UIFont fontWithName:@"HelveticaNeueLTStd-Hv" size:26.0];
        self.descriptionLabel.font = [UIFont fontWithName:@"HelveticaNeueLTStd-Hv" size:20.0];
        
    }
    
}

- (void)configureWithInt:(NSInteger)value {
    self.itemLabel.text = @"girl code";
    self.descriptionLabel.text = @"watch a sneak peak";
}

@end
