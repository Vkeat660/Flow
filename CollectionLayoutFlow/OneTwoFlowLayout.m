//
//  OneTwoFlowLayout.m
//  CollectionLayoutFlow
//
//  Created by Zian Chen on 6/15/15.
//  Copyright (c) 2015 Zian Chen. All rights reserved.
//

#import "OneTwoFlowLayout.h"

static const CGFloat kCellRatio = 9.0/16.0;

@interface OneTwoFlowLayout ()
@property (nonatomic, strong) NSMutableArray *itemSizes;
@property (nonatomic, assign) CGSize contentSize;
@end

@implementation OneTwoFlowLayout

#pragma mark - Initialization

- (id)init {
    self = [super init];
    if (self) {
        [self initialize];
    }
    return self;
}


- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self initialize];
    }
    return self;
}


- (void)initialize {
    _itemSizes = [NSMutableArray array];
}


#pragma mark - Collection View Settings

- (void)prepareLayout {
    [super prepareLayout];
    
    [_itemSizes removeAllObjects];
    
    NSInteger totalNumberOfItems = 0;
    
    for (int i = 0; i < [self.collectionView numberOfSections]; i++) {
        totalNumberOfItems += [self.collectionView numberOfItemsInSection:i];
    }
    
    if (totalNumberOfItems == 0) {
        return;
    }
    
    for (int i = 0; i < totalNumberOfItems; i++) {
        if (self.collectionView.traitCollection.horizontalSizeClass == UIUserInterfaceSizeClassRegular) {
            
            CGRect itemFrame = [self getRegularItemFrameForItemIndex:i];
            [_itemSizes addObject:[NSValue valueWithCGRect:itemFrame]];
            //NSLog(@"Index Row: %d, Attributes: %@", i, NSStringFromCGRect(itemFrame));
            
        } else if (self.collectionView.traitCollection.horizontalSizeClass == UIUserInterfaceSizeClassCompact) {
            CGRect itemFrame = [self getCompactItemFrameForItemIndex:i];
            [_itemSizes addObject:[NSValue valueWithCGRect:itemFrame]];
            //NSLog(@"Index Row: %d, Attributes: %@", i, NSStringFromCGRect(itemFrame));
        }
    }
    
    if ([_itemSizes count] > 0) {
        CGRect lastItemRect = [[self.itemSizes lastObject] CGRectValue];
        self.contentSize = CGSizeMake(self.collectionView.frame.size.width, CGRectGetMaxY(lastItemRect));
    }
    
}

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
    
    NSMutableArray *layoutAttributes = [NSMutableArray array];
    
    for (int i = 0; i < [self.itemSizes count]; i++) {
        if (CGRectIntersectsRect(rect, [self.itemSizes[i] CGRectValue])) {
            UICollectionViewLayoutAttributes * attributes = [self layoutAttributesForItemAtIndexPath:[NSIndexPath indexPathForItem:i inSection:0]];
            [layoutAttributes addObject:attributes];
        }
    }
    
    return layoutAttributes;
}


- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    UICollectionViewLayoutAttributes *attributes = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
    
    attributes.frame = [self.itemSizes[indexPath.row] CGRectValue];
    
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
    return [self getRegularItemFrameForItemIndex:indexPath.row];
}


- (CGRect)getRegularItemFrameForItemIndex:(NSInteger)itemIndex {
    
    CGFloat collectionViewHeight = self.collectionView.frame.size.height;
    CGFloat collectionViewWidth = self.collectionView.frame.size.width;
    
    CGFloat largeItemWidth = collectionViewWidth*2/3;   //2/3 of the width;
    CGFloat smallItemWidth = collectionViewWidth/3;     //1/3 of the width;
    
    CGFloat largeItemHeight = collectionViewHeight/2;   //1/2 of the height;
    CGFloat smallItemHeight = collectionViewHeight/4;   //1/4 of the height;
    
    // 0, 3, 4 has offset 0
    CGFloat xOffset = 0;
    if (itemIndex % 6 == 1 || itemIndex % 6 == 2) {
        xOffset = largeItemWidth;
    } else if (itemIndex % 6 == 5) {
        xOffset = smallItemWidth;
    }
    
    //In each 3 items group, both 1st and 2nd object start with the last set's height, but the 3rd one will add a small item height to it.
    CGFloat yOffsetAddition = (itemIndex % 6 == 2 || itemIndex % 6 == 4) ? smallItemHeight : 0;
    CGFloat yOffset = (itemIndex / 3) * largeItemHeight + yOffsetAddition;
    
    //Every 0th and 5th item is big item...
    BOOL isBigItem = (itemIndex % 6 == 0 || itemIndex % 6 == 5);
    CGFloat itemWidth = isBigItem ? largeItemWidth : smallItemWidth;
    CGFloat itemHeight = isBigItem ? largeItemHeight : smallItemHeight;
    
    return CGRectMake(xOffset, yOffset, itemWidth, itemHeight);
}


- (CGRect)getCompactItemFrameForIndexPath:(NSIndexPath *)indexPath {
    return [self getCompactItemFrameForItemIndex:indexPath.row];
}


- (CGRect)getCompactItemFrameForItemIndex:(NSInteger)itemIndex {
    
    CGFloat collectionViewWidth = self.collectionView.frame.size.width;
    
    CGFloat itemWidth = collectionViewWidth;
    CGFloat itemHeight = collectionViewWidth * kCellRatio;
    CGFloat xOffset = 0;
    CGFloat yOffset = itemIndex * itemHeight;
    
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
    
    CGFloat itemHeight = collectionViewWidth * kCellRatio;
    CGFloat fullHeight = itemHeight * totalNumberOfItems;
    
    //NSLog(@"Number of items: %ld - Total: %f", totalNumberOfItems, fullHeight);
    
    return CGSizeMake(collectionViewWidth, fullHeight);
}


- (NSInteger)totalItems {
    
    NSInteger totalNumberOfItems = 0;
    
    for (int i = 0; i < [self.collectionView numberOfSections]; i++) {
        totalNumberOfItems =  [self.collectionView numberOfItemsInSection:i];
    }
    
    return totalNumberOfItems;
}


@end
