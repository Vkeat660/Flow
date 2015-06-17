//
//  ViewController.m
//  CollectionLayoutFlow
//
//  Created by Zian Chen on 6/15/15.
//  Copyright (c) 2015 Zian Chen. All rights reserved.
//

#import "ViewController.h"
#import "OneTwoFlowLayout.h"
#import "FlowCell.h"

@interface ViewController () <UICollectionViewDataSource, UICollectionViewDelegate>
@property (nonatomic, strong) NSIndexPath *currentVisibleItem;
@property (nonatomic, strong) NSArray *colorArray;
@property (nonatomic, weak) IBOutlet UICollectionView *collectionView;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _colorArray = @[[UIColor redColor], [UIColor orangeColor], [UIColor yellowColor], [UIColor greenColor], [UIColor cyanColor], [UIColor blueColor]];
    self.collectionView.collectionViewLayout = [OneTwoFlowLayout new];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 20;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    FlowCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"FlowCell" forIndexPath:indexPath];
    cell.contentView.backgroundColor = [UIColor colorWithHue:((indexPath.row + 10) % 20) * .05 saturation:.8 brightness:.8 alpha:1.0];
    
    cell.itemLabel.text = @"girl code";
    cell.descriptionLabel.text = @"watch a sneak peak";
    cell.snipeLabel.text = @"premieres tonight 10/9c";
    
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
