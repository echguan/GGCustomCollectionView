//
//  GGImageShowView.h
//  GGCustomCollectionView
//
//  Created by hyg on 16/4/11.
//  Copyright © 2016年 echgg. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GGImageShowView : UIScrollView<UIScrollViewDelegate>

@property (nonatomic, strong, readonly) UIImageView *showImageView;
-(void)setImageViewWithImage:(UIImage*)image;
-(id)initWithFrame:(CGRect)frame andImage:(UIImage *)image;
@end
