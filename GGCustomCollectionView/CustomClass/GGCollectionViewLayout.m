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
    CGFloat cellWidth;
    CGPoint center;
    CGFloat radius;
}


-(void)prepareLayout
{
    [super prepareLayout];
    cellCount = [self.collectionView numberOfItemsInSection:0];
    CGSize size = self.collectionView.frame.size;
    center = CGPointMake(size.width / 2.0, size.height / 2.0);
    cellWidth = (KSCREENWIDTH - 20)  / 3;
    radius = MIN(size.width, size.height) / 2.5;

}

-(CGSize)collectionViewContentSize
{
    return CGSizeMake(cellWidth, cellWidth);
}

-(NSArray *)layoutAttributesForElementsInRect:(CGRect)rect
{
//    NSArray *array = [super layoutAttributesForElementsInRect:rect];
    NSMutableArray *array  = [[NSMutableArray alloc] init];
    for (NSInteger i=0 ; i < cellCount; i++) {
        NSIndexPath* indexPath = [NSIndexPath indexPathForItem:i inSection:0];
        [array addObject:[self layoutAttributesForItemAtIndexPath:indexPath]];
    }
    return array;
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)path
{
    UICollectionViewLayoutAttributes* attributes = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:path]; //生成空白的attributes对象，其中只记录了类型是cell以及对应的位置是indexPath
    //配置attributes到圆周上
    attributes.size = CGSizeMake(cellWidth, cellWidth);
    attributes.center = CGPointMake(center.x + radius * cosf(2 * path.item * M_PI / cellCount), center.y + radius * sinf(2 * path.item * M_PI / cellCount));
    return attributes;
}



//- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect {
//
//
//}
@end
