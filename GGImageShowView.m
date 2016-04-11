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


-(id)initWithFrame:(CGRect)frame andImage:(UIImage *)image
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
            [self setMinimumZoomScale:3.0];
            [self setZoomScale:1.0];
            
        }
    }
    return self;
}

//-(void)setFrame:(CGRect)frame
//{
//    [super setFrame:frame];
//    if(!_showImageView)
//    {
//        self.delegate = self;
//        _showImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 10, frame.size.width, frame.size.height)];
//        [self addSubview:_showImageView];
//        _showImageView.userInteractionEnabled = YES;
////        [self adaptFrame:_showImageView];
//        [self setMinimumZoomScale:1.0];
//        [self setZoomScale:1.0];
//        
//    }
//}

-(void)setImageViewWithImage:(UIImage*)image
{
    [_showImageView setImage:image];
}

//-(void)adaptFrame:(UIImageView*)imge{
//    UIImageView *img = self.showImageView;
//    if (img.image.size.width > self.frame.size.width || img.image.size.height > self.frame.size.height) {
//        float a = img.image.size.width / self.frame.size.width;
//        float b = img.image.size.height / self.frame.size.height;
//        if (a >= b) {
//            img.frame = CGRectMake(0, (self.frame.size.height-img.image.size.height/a)/2, KSCREENWIDTH * MULTIPLE, img.image.size.height/a * MULTIPLE);
//        }else{
//            img.frame = CGRectMake((KSCREENWIDTH-img.image.size.width/b)/2, 0, img.image.size.width/b * MULTIPLE, self.frame.size.height * MULTIPLE);
//        }
//    }
//    else{
//        img.frame = CGRectMake((self.frame.size.width-img.image.size.width* MULTIPLE)/2, (self.frame.size.height-img.image.size.height* MULTIPLE)/2, img.image.size.width * MULTIPLE, img.image.size.height * MULTIPLE);
//    }
//}

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
