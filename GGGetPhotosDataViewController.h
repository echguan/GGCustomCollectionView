//
//  GGGetPhotosDataViewController.h
//  GGCustomCollectionView
//
//  Created by echgg on 16/2/29.
//  Copyright © 2016年 echgg. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AssetsLibrary/AssetsLibrary.h>

@protocol showPhotoDelegate <NSObject>

-(void)getImageData:(NSArray*)imageArray;

@end

@interface GGGetPhotosDataViewController : UIViewController{
    ALAssetsLibrary *library;
    NSArray *imageArray;
    NSMutableArray *mutableArray;
}
@property (weak, nonatomic) id<showPhotoDelegate> delegate;
-(void)getPhonePhotos;
@end
