//
//  ViewController.m
//  CollectionLayoutFlow
//
//  Created by Zian Chen on 6/15/15.
//  Copyright (c) 2015 Zian Chen. All rights reserved.
//

#import "ViewController.h"
#import "OneTwoFlowLayout.h"

@interface ViewController () <UICollectionViewDataSource, UICollectionViewDelegate>
@property (nonatomic, strong) NSIndexPath *currentVisibleItem;
@property (nonatomic, strong) NSArray *colorArray;
@property (nonatomic, weak) IBOutlet UICollectionView *collectionView;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _colorArray = @[[UIColor redColor], [UIColor orangeColor], [UIColor yellowColor], [UIColor greenColor], [UIColor cyanColor], [UIColor blueColor]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Collection Delegate

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 7;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CustomCell" forIndexPath:indexPath];
    if (cell == nil) {
        cell = [[UICollectionViewCell alloc] initWithFrame:CGRectZero];
    }
    cell.contentView.backgroundColor = self.colorArray[indexPath.row % 6];
    NSLog(@"Index path: %d - %d", indexPath.row, indexPath.section);
    return cell;
}


#pragma mark - Color generator

- (UIColor *)randomColor {
    CGFloat hue = ( arc4random() % 256 / 256.0 );  //  0.0 to 1.0
    CGFloat saturation = ( arc4random() % 128 / 256.0 ) + 0.5;  //  0.5 to 1.0, away from white
    CGFloat brightness = ( arc4random() % 128 / 256.0 ) + 0.5;  //  0.5 to 1.0, away from black
    UIColor *color = [UIColor colorWithHue:hue saturation:saturation brightness:brightness alpha:1];
    return color;
}


@end
