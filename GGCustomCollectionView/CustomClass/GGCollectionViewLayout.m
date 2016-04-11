//
//  GGCollectionViewLayout.m
//  GGCustomCollectionView
//
//  Created by echgg on 16/3/10.
//  Copyright © 2016年 echgg. All rights reserved.
//

#import "GGCollectionViewLayout.h"

@implementation UIImageView (RACollectionViewReorderableTripletLayout)

- (void)setCellCopiedImage:(UICollectionViewCell *)cell {
    UIGraphicsBeginImageContextWithOptions(cell.bounds.size, NO, 4.f);
    [cell.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    self.image = image;
}

@end

@implementation GGCollectionViewLayout{
    NSInteger cellCount;
    CGFloat cellWidth;
    CGPoint center;
    CGFloat radius;
    BOOL isSetuped;
    UIView *_cellFakeView;

}


-(void)prepareLayout
{
    [super prepareLayout];
    cellCount = [self.collectionView numberOfItemsInSection:0];
    CGSize size = self.collectionView.frame.size;
    center = CGPointMake(size.width / 2.0, size.height / 2.0);
    cellWidth = (KSCREENWIDTH - 20)  / 3;
    radius = MIN(size.width, size.height) / 2.5;
    [self setUpCollectionViewGesture];

}

-(void)setUpCollectionViewGesture
{
    if(!isSetuped)
    {
        _longPressGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongPressGesture:)];
        _longPressGesture.delegate = self;
        for (UIGestureRecognizer *gestureRecognizer in self.collectionView.gestureRecognizers) {
            if ([gestureRecognizer isKindOfClass:[UILongPressGestureRecognizer class]]) {
                [gestureRecognizer requireGestureRecognizerToFail:_longPressGesture]; }}
        [self.collectionView addGestureRecognizer:_longPressGesture];
        isSetuped = YES;
    }
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
    attributes.size = CGSizeMake(cellWidth, cellWidth );
//    attributes.center = CGPointMake(center.x + radius * cosf(2  * M_PI / cellCount), center.y + radius * sinf(2 * M_PI / cellCount));
//    attributes.center = CGPointMake(cellWidth * ((path.row + 1) % 3) / 2 + 5 * ((path.row + 1) % 3), (cellWidth * path.row / M_PI) / 2);
    attributes.frame = CGRectMake(cellWidth * (path.row % 3) + (path.row % 3 + 1) * 5 , cellWidth * (path.row / 3) + (path.row / 3 + 1) * 5, cellWidth, cellWidth);
    return attributes;
}

-(void)handleLongPressGesture:(UILongPressGestureRecognizer*)longPress
{
    switch (longPress.state) {
        case UIGestureRecognizerStateBegan: {
            //indexPath
            NSIndexPath *indexPath = [self.collectionView indexPathForItemAtPoint:[longPress locationInView:self.collectionView]];
            //can move
//            if ([self.datasource respondsToSelector:@selector(collectionView:canMoveItemAtIndexPath:)]) {
//                if (![self.datasource collectionView:self.collectionView canMoveItemAtIndexPath:indexPath]) {
//                    return;
//                }
//            }
//            //will begin dragging
//            if ([self.delegate respondsToSelector:@selector(collectionView:layout:willBeginDraggingItemAtIndexPath:)]) {
//                [self.delegate collectionView:self.collectionView layout:self willBeginDraggingItemAtIndexPath:indexPath];
//            }
//            
            //indexPath
//            _reorderingCellIndexPath = indexPath;
            //scrolls top off
            self.collectionView.scrollsToTop = NO;
            //cell fake view
            UICollectionViewCell *cell = [self.collectionView cellForItemAtIndexPath:indexPath];
            _cellFakeView = [[UIView alloc] initWithFrame:cell.frame];
            _cellFakeView.layer.shadowColor = [UIColor blackColor].CGColor;
            _cellFakeView.layer.shadowOffset = CGSizeMake(0, 0);
            _cellFakeView.layer.shadowOpacity = .5f;
            _cellFakeView.layer.shadowRadius = 3.f;
            UIImageView *cellFakeImageView = [[UIImageView alloc] initWithFrame:cell.bounds];
            UIImageView *highlightedImageView = [[UIImageView alloc] initWithFrame:cell.bounds];
            cellFakeImageView.contentMode = UIViewContentModeScaleAspectFill;
            highlightedImageView.contentMode = UIViewContentModeScaleAspectFill;
            cellFakeImageView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
            highlightedImageView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
            cell.highlighted = YES;
            [highlightedImageView setCellCopiedImage:cell];
            cell.highlighted = NO;
            [cellFakeImageView setCellCopiedImage:cell];
            [self.collectionView addSubview:_cellFakeView];
            [_cellFakeView addSubview:cellFakeImageView];
            [_cellFakeView addSubview:highlightedImageView];
            //set center
//            _reorderingCellCenter = cell.center;
//            _cellFakeViewCenter = _cellFakeView.center;
            [self invalidateLayout];
            //animation
            CGRect fakeViewRect = CGRectMake(cell.center.x - (cellWidth / 2.f), cell.center.y - (cellWidth / 2.f), cellWidth / 2.0, cellWidth / 2.0);
            [UIView animateWithDuration:.3f delay:0 options:UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionCurveEaseInOut animations:^{
                _cellFakeView.center = cell.center;
                _cellFakeView.frame = fakeViewRect;
                _cellFakeView.transform = CGAffineTransformMakeScale(1.1f, 1.1f);
                highlightedImageView.alpha = 0;
            } completion:^(BOOL finished) {
                [highlightedImageView removeFromSuperview];
            }];
            //did begin dragging
//            if ([self.delegate respondsToSelector:@selector(collectionView:layout:didBeginDraggingItemAtIndexPath:)]) {
//                [self.delegate collectionView:self.collectionView layout:self didBeginDraggingItemAtIndexPath:indexPath];
//            }
            break;
        }
        case UIGestureRecognizerStateEnded:
        case UIGestureRecognizerStateCancelled: {
//            NSIndexPath *currentCellIndexPath = _reorderingCellIndexPath;
//            //will end dragging
//            if ([self.delegate respondsToSelector:@selector(collectionView:layout:willEndDraggingItemAtIndexPath:)]) {
//                [self.delegate collectionView:self.collectionView layout:self willEndDraggingItemAtIndexPath:currentCellIndexPath];
//            }
//            
//            //scrolls top on
//            self.collectionView.scrollsToTop = YES;
//            //disable auto scroll
//            [self invalidateDisplayLink];
//            //remove fake view
//            UICollectionViewLayoutAttributes *attributes = [self layoutAttributesForItemAtIndexPath:currentCellIndexPath];
//            [UIView animateWithDuration:.3f delay:0 options:UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionCurveEaseInOut animations:^{
//                _cellFakeView.transform = CGAffineTransformIdentity;
//                _cellFakeView.frame = attributes.frame;
//            } completion:^(BOOL finished) {
//                [_cellFakeView removeFromSuperview];
//                _cellFakeView = nil;
//                _reorderingCellIndexPath = nil;
//                _reorderingCellCenter = CGPointZero;
//                _cellFakeViewCenter = CGPointZero;
//                [self invalidateLayout];
//                if (finished) {
//                    //did end dragging
//                    if ([self.delegate respondsToSelector:@selector(collectionView:layout:didEndDraggingItemAtIndexPath:)]) {
//                        [self.delegate collectionView:self.collectionView layout:self didEndDraggingItemAtIndexPath:currentCellIndexPath];
//                    }
//                }
//            }];
            break;
        }
        default:
            break;
    }
}

//- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect {
//
//
//}
@end
