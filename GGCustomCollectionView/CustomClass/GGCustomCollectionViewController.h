//
//  GGCustomCollectionViewController.h
//  GGCustomCollectionView
//
//  Created by echgg on 15/5/2.
//  Copyright (c) 2015年 echgg. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GGCustomCollectionViewController : UICollectionViewController<UICollectionViewDataSource, UICollectionViewDelegate>
@property (nonatomic, strong) UICollectionView *myCollectionView;
@end
