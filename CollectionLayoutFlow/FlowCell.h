//
//  FlowCell.h
//  CollectionLayoutFlow
//
//  Created by Zian Chen on 6/16/15.
//  Copyright (c) 2015 Zian Chen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FlowCell : UICollectionViewCell
@property (nonatomic, weak) IBOutlet UILabel *itemLabel;
@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;
- (void)configureWithInt:(NSInteger)value;
@end
