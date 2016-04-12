//
//  GGCustomCollectionViewController.h
//  GGCustomCollectionView
//
//  Created by echgg on 15/5/2.
//  Copyright (c) 2015年 echgg. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GGGetPhotosDataViewController.h"
@interface GGCustomCollectionViewController : UICollectionViewController<UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout,showPhotoDelegate>
@property (nonatomic, strong) UICollectionView *myCollectionView;
@property (nonatomic, strong) NSMutableArray  *showDataInfoArray;
@property (nonatomic, strong, readonly) UIScrollView *showImageScrollView;
@end
