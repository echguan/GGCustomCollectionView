//
//  GGImageShowView.m
//  GGCustomCollectionView
//
//  Created by hyg on 16/4/11.
//  Copyright © 2016年 echgg. All rights reserved.
//

#import "GGImageShowView.h"
#define MULTIPLE 2.5

@implementation GGImageShowView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/


-(instancetype)initWithFrame:(CGRect)frame andImage:(UIImage *)image
{
    self = [super initWithFrame:frame];
    if(self)
    {
        if(!_showImageView)
        {
            self.delegate = self;
            _showImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 10, frame.size.width, frame.size.height)];
            [self addSubview:_showImageView];
            _showImageView.userInteractionEnabled = YES;
            [_showImageView setImage:image];
            //        [self adaptFrame:_showImageView];
//            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(removeSelf:)];
//            [_showImageView addGestureRecognizer:tap];
            [self setMinimumZoomScale:3.0];
            [self setZoomScale:1.0];
            
        }
        self.backgroundColor = [UIColor blackColor];
    }
    return self;
}

//-(void)removeSelf:(UIGestureRecognizer*)ges
//{
//    [self removeFromSuperview];
//}

-(void)setImageViewWithImage:(UIImage*)image
{
    [_showImageView setImage:image];
}

//返回需要缩放的控件 需要在初始化时将showImage赋值否则会crash
-(UIView*)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return  self.showImageView;
}
//缩放过程
-(void)scrollViewDidZoom:(UIScrollView *)scrollView
{
    CGFloat offset_X = (scrollView.bounds.size.width > scrollView.contentSize.width)?(scrollView.bounds.size.width - scrollView.contentSize.width)/2 : 0.0;
    CGFloat offset_Y = (scrollView.bounds.size.height > scrollView.contentSize.height)?(scrollView.bounds.size.height - scrollView.contentSize.height)/2 : 0.0;
    self.showImageView.center = CGPointMake(scrollView.contentSize.width/2 + offset_X,scrollView.contentSize.height/2 + offset_Y);
}

-(void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(CGFloat)scale
{
    [scrollView setZoomScale:scale animated:YES];
}

@end
