//
//  OneTwoFlowLayout.m
//  CollectionLayoutFlow
//
//  Created by Zian Chen on 6/15/15.
//  Copyright (c) 2015 Zian Chen. All rights reserved.
//

#import "OneTwoFlowLayout.h"

@interface OneTwoFlowLayout ()
@end

@implementation OneTwoFlowLayout

- (CGSize)collectionViewContentSize {
    
    CGSize contentSize = CGSizeZero;
    
    if (self.collectionView.traitCollection.horizontalSizeClass == UIUserInterfaceSizeClassRegular) {
        contentSize = [self getRegularContentSize];
        
    } else if (self.collectionView.traitCollection.horizontalSizeClass == UIUserInterfaceSizeClassCompact) {
        contentSize = [self getCompactContentSize];
    }
    
    return contentSize;
}


- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect {
    NSArray* attributesToReturn = [super layoutAttributesForElementsInRect:rect];
    for (UICollectionViewLayoutAttributes* attributes in attributesToReturn) {
        if (attributes.representedElementKind == nil) {
            NSIndexPath* indexPath = attributes.indexPath;
            attributes.frame = [self layoutAttributesForItemAtIndexPath:indexPath].frame;
        //NSLog(@"Attribute frame: %@", NSStringFromCGRect(attributes.frame));
        }
    }
    return attributesToReturn;
}


- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    UICollectionViewLayoutAttributes *attributes = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
    
    //NSLog(@"Trait class: %d", self.collectionView.traitCollection.horizontalSizeClass);
    
    if (self.collectionView.traitCollection.horizontalSizeClass == UIUserInterfaceSizeClassRegular) {
        
        attributes.frame = [self getRegularItemFrameForIndexPath:indexPath];
        //NSLog(@"Index Row: %ld, Attributes: %@", (long)indexPath.row, NSStringFromCGRect(attributes.frame));
        
    } else if (self.collectionView.traitCollection.horizontalSizeClass == UIUserInterfaceSizeClassCompact) {
        attributes.frame = [self getCompactItemFrameForIndexPath:indexPath];
        //NSLog(@"Index Row: %ld, Attributes: %@", (long)indexPath.row, NSStringFromCGRect(attributes.frame));
    }
    
    
    return attributes;
}

- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds
{
    CGRect oldBounds = self.collectionView.bounds;
    if (CGRectGetWidth(newBounds) != CGRectGetWidth(oldBounds)) {
        return YES;
    }
    return NO;
}


#pragma mark - Item Frame Methods

- (CGRect)getRegularItemFrameForIndexPath:(NSIndexPath *)indexPath {
    
    CGFloat collectionViewHeight = self.collectionView.frame.size.height;
    CGFloat collectionViewWidth = self.collectionView.frame.size.width;
    
    CGFloat largeItemWidth = collectionViewWidth*2/3;   //2/3 of the width;
    CGFloat smallItemWidth = collectionViewWidth/3;     //1/3 of the width;
    
    CGFloat largeItemHeight = collectionViewHeight/2;   //1/2 of the height;
    CGFloat smallItemHeight = collectionViewHeight/4;   //1/4 of the height;
    
    // 0, 3, 4 has offset 0
    CGFloat xOffset = 0;
    if (indexPath.row % 6 == 1 || indexPath.row % 6 == 2) {
        xOffset = largeItemWidth;
    } else if (indexPath.row % 6 == 5) {
        xOffset = smallItemWidth;
    }
    
    //In each 3 items group, both 1st and 2nd object start with the last set's height, but the 3rd one will add a small item height to it.
    CGFloat yOffsetAddition = (indexPath.row % 6 == 2 || indexPath.row % 6 == 4) ? smallItemHeight : 0;
    CGFloat yOffset = (indexPath.row / 3) * largeItemHeight + yOffsetAddition;
    
    //Every 0th and 5th item is big item...
    BOOL isBigItem = (indexPath.row % 6 == 0 || indexPath.row % 6 == 5);
    CGFloat itemWidth = isBigItem ? largeItemWidth : smallItemWidth;
    CGFloat itemHeight = isBigItem ? largeItemHeight : smallItemHeight;
    
    return CGRectMake(xOffset, yOffset, itemWidth, itemHeight);
}


- (CGRect)getCompactItemFrameForIndexPath:(NSIndexPath *)indexPath {
    CGFloat collectionViewWidth = self.collectionView.frame.size.width;
    
    CGFloat itemWidth = collectionViewWidth;
    CGFloat itemHeight = collectionViewWidth * 3/4;
    CGFloat xOffset = 0;
    CGFloat yOffset = indexPath.row * itemHeight;
    
    return CGRectMake(xOffset, yOffset, itemWidth, itemHeight);
}


#pragma mark - Content Size Method

- (CGSize)getRegularContentSize {
    
    NSInteger totalNumberOfItems = 0;
    for (int i = 0; i < [self.collectionView numberOfSections]; i++) {
        totalNumberOfItems += [self.collectionView numberOfItemsInSection:i];
    }
    
    if (totalNumberOfItems == 0) {
        return CGSizeZero;
    }
    
    CGFloat collectionViewWidth = self.collectionView.frame.size.width;
    CGFloat collectionViewHeight = self.collectionView.frame.size.height;
    
    CGFloat largeItemHeight = collectionViewHeight/2;   //1/2 of the height;
    CGFloat smallItemHeight = collectionViewHeight/4;   //1/4 of the height;
    
    CGFloat rowHeight = (totalNumberOfItems / 3) * largeItemHeight;
    CGFloat partialRowHeight = 0;
    
    if (totalNumberOfItems % 3 == 0) {
        partialRowHeight = 0;
    } else if (totalNumberOfItems % 6 == 4) {
        partialRowHeight = smallItemHeight;
    } else {
        partialRowHeight = largeItemHeight;
    }
    
    //NSLog(@"Number of items: %ld - Full: %f, Partial %f, Total: %f", (long)totalNumberOfItems, rowHeight, partialRowHeight, rowHeight + partialRowHeight);
    return CGSizeMake(collectionViewWidth, rowHeight + partialRowHeight);
}


- (CGSize)getCompactContentSize {
    
    NSInteger totalNumberOfItems = 0;
    for (int i = 0; i < [self.collectionView numberOfSections]; i++) {
        totalNumberOfItems += [self.collectionView numberOfItemsInSection:i];
    }
    
    if (totalNumberOfItems == 0) {
        return CGSizeZero;
    }
    
    CGFloat collectionViewWidth = self.collectionView.frame.size.width;
    
    CGFloat itemHeight = collectionViewWidth * 3/4;
    
    return CGSizeMake(collectionViewWidth, itemHeight * totalNumberOfItems);
}


@end
