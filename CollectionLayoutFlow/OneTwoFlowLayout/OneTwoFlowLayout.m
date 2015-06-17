//
//  OneTwoFlowLayout.m
//  CollectionLayoutFlow
//
//  Created by Zian Chen on 6/15/15.
//  Copyright (c) 2015 Zian Chen. All rights reserved.
//

#import "OneTwoFlowLayout.h"

//NOTE: This class may not be available for multiple sections for now...

static const CGFloat kCellRatio = 9.0/16.0;

@interface OneTwoFlowLayout ()
@property (nonatomic, strong) NSMutableDictionary *itemsLayoutInfo;  //Array of one two layout info
@end

@implementation OneTwoFlowLayout

#pragma mark - Initialization

- (id)init
{
    self = [super init];
    if (self) {
        [self initialize];
    }
    return self;
}


- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self initialize];
    }
    return self;
}


- (void)initialize
{
    _itemsLayoutInfo = [NSMutableDictionary dictionary];
}



#pragma mark - Collection View Settings

- (void)prepareLayout
{
    [super prepareLayout];
    
    [_itemsLayoutInfo removeAllObjects];
    
    for (int section = 0; section < [self.collectionView numberOfSections]; section++) {
        for (int item = 0; item < [self.collectionView numberOfItemsInSection:section]; item++) {
            NSIndexPath *indexPath = [NSIndexPath indexPathForItem:item inSection:section];
            
            if (_itemsLayoutInfo[indexPath] == nil) {
                CGRect itemFrame = CGRectZero;
                if (self.collectionView.traitCollection.horizontalSizeClass == UIUserInterfaceSizeClassRegular) {
                    itemFrame = [self getRegularItemFrameForIndexPath:indexPath];
                    //NSLog(@"Index Row: %d, Attributes: %@", i, NSStringFromCGRect(itemFrame));
                    
                } else if (self.collectionView.traitCollection.horizontalSizeClass == UIUserInterfaceSizeClassCompact) {
                    itemFrame = [self getCompactItemFrameForIndexPath:indexPath];
                    //NSLog(@"Index Row: %d, Attributes: %@", i, NSStringFromCGRect(itemFrame));
                }
                
                _itemsLayoutInfo[indexPath] = [NSValue valueWithCGRect:itemFrame];
            }
        }
    }
}

- (CGSize)collectionViewContentSize
{
    CGSize contentSize = CGSizeZero;
    
    if (self.collectionView.traitCollection.horizontalSizeClass == UIUserInterfaceSizeClassRegular) {
        contentSize = [self getRegularContentSize];
        
    } else if (self.collectionView.traitCollection.horizontalSizeClass == UIUserInterfaceSizeClassCompact) {
        contentSize = [self getCompactContentSize];
    }
    return contentSize;
}

- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect
{
    NSMutableArray *layoutAttributes = [NSMutableArray array];
    
    for (NSIndexPath *indexPath in [self.itemsLayoutInfo allKeys]) {
        CGRect layoutRect = [self.itemsLayoutInfo[indexPath] CGRectValue];
        if (CGRectIntersectsRect(layoutRect, rect)) {
            UICollectionViewLayoutAttributes *attributes = [self layoutAttributesForItemAtIndexPath:indexPath];
            [layoutAttributes addObject:attributes];
        }
    }
    
    return layoutAttributes;
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewLayoutAttributes *attributes = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
    
    if (self.collectionView.traitCollection.horizontalSizeClass == UIUserInterfaceSizeClassRegular) {
        attributes.frame = [self.itemsLayoutInfo[indexPath] CGRectValue];
        //NSLog(@"Index Row: %d, Attributes: %@", i, NSStringFromCGRect(itemFrame));
        
    } else if (self.collectionView.traitCollection.horizontalSizeClass == UIUserInterfaceSizeClassCompact) {
        attributes.frame = [self.itemsLayoutInfo[indexPath] CGRectValue];
        //NSLog(@"Index Row: %d, Attributes: %@", i, NSStringFromCGRect(itemFrame));
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
    return [self getRegularItemFrameForItemIndex:indexPath.row];
}

//TODO: Need to modify to compatible with sections.
- (CGRect)getRegularItemFrameForItemIndex:(NSInteger)itemIndex
{
    CGFloat collectionViewHeight = self.collectionView.frame.size.height;
    CGFloat collectionViewWidth = self.collectionView.frame.size.width;
    
    CGFloat largeItemWidth = ceil(collectionViewWidth*2/3);   //2/3 of the width;
    CGFloat smallItemWidth = floor(collectionViewWidth/3);     //1/3 of the width;
    
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


- (CGRect)getCompactItemFrameForIndexPath:(NSIndexPath *)indexPath
{
    return [self getCompactItemFrameForItemIndex:indexPath.row];
}

//TODO: Need to modify to compatible with sections.
- (CGRect)getCompactItemFrameForItemIndex:(NSInteger)itemIndex
{
    CGFloat collectionViewWidth = self.collectionView.frame.size.width;
    
    CGFloat itemWidth = collectionViewWidth;
    CGFloat itemHeight = collectionViewWidth * kCellRatio;
    CGFloat xOffset = 0;
    CGFloat yOffset = itemIndex * itemHeight;
    
    return CGRectMake(xOffset, yOffset, itemWidth, itemHeight);
}


#pragma mark - Content Size Method

- (CGSize)getRegularContentSize
{
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

- (CGSize)getCompactContentSize
{
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

- (NSInteger)totalItems
{
    NSInteger totalNumberOfItems = 0;
    
    for (int i = 0; i < [self.collectionView numberOfSections]; i++) {
        totalNumberOfItems =  [self.collectionView numberOfItemsInSection:i];
    }
    
    return totalNumberOfItems;
}


@end
