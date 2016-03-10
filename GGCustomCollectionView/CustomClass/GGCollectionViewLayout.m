//
//  GGCollectionViewLayout.m
//  GGCustomCollectionView
//
//  Created by echgg on 16/3/10.
//  Copyright © 2016年 echgg. All rights reserved.
//

#import "GGCollectionViewLayout.h"

@implementation GGCollectionViewLayout{
    NSInteger cellCount;
}


-(void)prepareLayout
{
    [super prepareLayout];
    cellCount = [self.collectionView numberOfItemsInSection:0];
}

-(CGSize)collectionViewContentSize
{
    return CGSizeMake(KSCREENWIDTH, KSCREENHEIGHT);
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewLayoutAttributes *attributes = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
    return attributes;
}

//- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect {
//
//
//}
@end
