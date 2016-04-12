//
//  GGCustomCollectionViewController.m
//  GGCustomCollectionView
//
//  Created by echgg on 15/5/2.
//  Copyright (c) 2015年 echgg. All rights reserved.
//
#define CELLWIDTH (KSCREENWIDTH - 20)  / 3
#define SHOWIMAGESCROLLMODE 0x111
#import "GGCustomCollectionViewController.h"
#import "GGCustomCollectionViewCell.h"
#import "GGCollectionViewLayout.h"
#import "GGImageShowView.h"
#import <MJRefresh.h>

@interface GGCustomCollectionViewController ()

@end

@implementation GGCustomCollectionViewController{
    GGGetPhotosDataViewController *imageViewController;
    NSInteger currentPage;//当前展示的相片
}

static NSString * const reuseIdentifier = @"Cell";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Register cell classes
//    [self.collectionView registerClass:[GGCustomCollectionViewCell class] forCellWithReuseIdentifier:reuseIdentifier];
    _showDataInfoArray = [[NSMutableArray alloc] init];
    [self initData];
    [self initCollectionview];
    // Do any additional setup after loading the view.
}

-(void)initCollectionview
{
//    UICollectionViewFlowLayout *layout = [UICollectionViewFlowLayout new];
//    self.myCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, KSCREENWIDTH ,KSCREENHEIGHT) collectionViewLayout:layout];
//    [self.view addSubview:_myCollectionView];
//    _myCollectionView.delegate = self;
//    _myCollectionView.dataSource = self;
//    [_myCollectionView registerClass:[GGCustomCollectionViewCell class] forCellWithReuseIdentifier:reuseIdentifier];
    self.collectionView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self  refreshData];
    }];
    self.collectionView.mj_footer = [MJRefreshAutoFooter footerWithRefreshingBlock:^{
        [self addMoreData];
    }];
}

-(void)refreshData
{
    [self.collectionView reloadData];
    [self.collectionView.mj_header endRefreshing];
}

-(void)addMoreData
{
//    [_showDataInfoArray addObjectsFromArray:_showDataInfoArray];
//    [self.collectionView reloadData];
//    [self.collectionView.mj_footer endRefreshing];
}

-(void)initData
{
//    _showDataInfoArray = [[NSMutableArray alloc] init];
//    GGGetPhotosData *data = [GGGetPhotosData new];
    imageViewController = [[GGGetPhotosDataViewController alloc] init];
    imageViewController.delegate = self;
    [imageViewController getPhonePhotos];
//    _showDataInfoArray = [[NSMutableArray alloc] initWithArray:[data getPhonePhotos]];
//    [_myCollectionView reloadData];
}

#pragma mark ----- delegate -----

-(void)getImageData:(NSArray*)imageArray
{
    _showDataInfoArray = [[NSMutableArray alloc] initWithArray:imageArray];
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.collectionView reloadData];
    });}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [_showDataInfoArray count];
}
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    GGCustomCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    if(!cell)
    {
        cell = [[GGCustomCollectionViewCell alloc] init];
    }
//    __block UIImage* thumbnail;
//    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//        ALAsset *asset =  (ALAsset*)[_showDataInfoArray objectAtIndex:indexPath.row];
//        thumbnail = [[UIImage alloc] initWithCGImage:[[asset defaultRepresentation] fullScreenImage] scale:UIViewContentModeScaleAspectFit orientation:UIImageOrientationUp];
//        dispatch_async(dispatch_get_main_queue(), ^{
//            cell.myImage.image = thumbnail;
//        });
//    });
    
    PHImageRequestOptions *options = [[PHImageRequestOptions alloc] init];
    options.deliveryMode = PHImageRequestOptionsDeliveryModeHighQualityFormat;
    options.networkAccessAllowed = YES;
    CGFloat scale = [UIScreen mainScreen].scale;
    CGSize targetSize = CGSizeMake(CGRectGetWidth(cell.myImage.bounds) * scale, CGRectGetHeight(cell.myImage.bounds) * scale);
    [[PHImageManager defaultManager] requestImageForAsset:(PHAsset*)[_showDataInfoArray objectAtIndex:indexPath.row] targetSize:targetSize contentMode:PHImageContentModeAspectFit options:options resultHandler:^(UIImage *result, NSDictionary *info) {
        // Hide the progress view now the request has completed.
//        self.progressView.hidden = YES;
        
        // Check if the request was successful.
        if (!result) {
            return;
        }
        cell.myImage.image = result;
    }];
    cell.nameLabel.text = @"hello";
    return cell;
}

#pragma mark <UICollectionViewDelegate>
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"cell's index is %ld", indexPath.row + indexPath.section * 10);
    if(!_showImageScrollView)
    {
        _showImageScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, KSCREENWIDTH, KSCREENHEIGHT)];
        [self.view addSubview:_showImageScrollView];
        [_showImageScrollView setContentSize:CGSizeMake([_showDataInfoArray count] * KSCREENWIDTH, KSCREENHEIGHT)];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(removeScrollView:)];
        [self.view addSubview:_showImageScrollView];
        _showImageScrollView.delegate = self;
        [_showImageScrollView setPagingEnabled:YES];
        [_showImageScrollView addGestureRecognizer:tap];
        _showImageScrollView.tag = SHOWIMAGESCROLLMODE;
    }
    PHImageRequestOptions *options = [[PHImageRequestOptions alloc] init];
    options.deliveryMode = PHImageRequestOptionsDeliveryModeHighQualityFormat;
    options.networkAccessAllowed = YES;
    for(NSInteger i = 0; i != [_showDataInfoArray count]; i++)
        [[PHImageManager defaultManager] requestImageForAsset:(PHAsset*)[_showDataInfoArray objectAtIndex:i] targetSize:PHImageManagerMaximumSize contentMode:PHImageContentModeAspectFit options:options resultHandler:^(UIImage *result, NSDictionary *info) {
            if (!result) {
                return;
            }
            GGImageShowView *showView = [[GGImageShowView alloc] initWithFrame:CGRectMake(i* KSCREENWIDTH, 0, KSCREENWIDTH, KSCREENHEIGHT) andImage:result];
            [_showImageScrollView addSubview:showView];
        }];
    currentPage = indexPath.row;
    [_showImageScrollView setContentOffset:CGPointMake(indexPath.row * KSCREENWIDTH, 0)];
}

#pragma mark <UICollectionViewDelegateFlowLayout>

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(CELLWIDTH, CELLWIDTH);
}

-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(10, 0, 0, 0);
}

-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 0;
}

-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 10;
}

-(void)collectionView:(UICollectionView *)collectionView moveItemAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath
{
    PHAsset *pha = [_showDataInfoArray objectAtIndex:sourceIndexPath.item];
    [_showDataInfoArray removeObjectAtIndex:sourceIndexPath.item];
    [_showDataInfoArray insertObject:pha atIndex:destinationIndexPath.item];
}

-(BOOL)collectionView:(UICollectionView *)collectionView canMoveItemAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (BOOL)collectionView:(UICollectionView *)collectionView itemAtIndexPath:(NSIndexPath *)fromIndexPath canMoveToIndexPath:(NSIndexPath *)toIndexPath
{
    return YES;
}

- (IBAction)handlelongGesture:(id)sender {
    UILongPressGestureRecognizer *longGesture = (UILongPressGestureRecognizer*)sender;
    switch (longGesture.state) {
        case UIGestureRecognizerStateBegan:{
            //判断手势落点位置是否在路径上
            NSIndexPath *indexPath = [self.collectionView indexPathForItemAtPoint:[longGesture locationInView:self.collectionView]];
            if (indexPath == nil) {
                break;
            }
            //在路径上则开始移动该路径上的cell
            [self.collectionView beginInteractiveMovementForItemAtIndexPath:indexPath];
        }
            break;
        case UIGestureRecognizerStateChanged:
            //移动过程当中随时更新cell位置
            [self.collectionView updateInteractiveMovementTargetPosition:[longGesture locationInView:self.collectionView]];
            break;
        case UIGestureRecognizerStateEnded:
            //移动结束后关闭cell移动
            [self.collectionView endInteractiveMovement];
            break;
        default:
            [self.collectionView cancelInteractiveMovement];
            break;
    }
}
#pragma mark ---- gesture action ----
-(void)removeScrollView:(UIGestureRecognizer*)ges
{
    [_showImageScrollView removeFromSuperview];
    _showImageScrollView = nil;
}

#pragma mark ---- scrollview delegate ----

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if(scrollView.tag == SHOWIMAGESCROLLMODE)
    {
        
    }
}


//- (void)prepareLayout {
//    
//    [super prepareLayout];
//    // 初始化参数
//    _cellCount = [self.collectionView numberOfItemsInSection:0]; // cell个数，直接从collectionView中获得
//    _insert = 10; // 设置间距
//    _itemWidth = SCREEN_WIDTH / 2 - 3 * _insert; // cell宽度
//}

/*
// Uncomment this method to specify if the specified item should be highlighted during tracking
- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath {
	return YES;
}
*/

/*
// Uncomment this method to specify if the specified item should be selected
- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}
*/

/*
// Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
- (BOOL)collectionView:(UICollectionView *)collectionView shouldShowMenuForItemAtIndexPath:(NSIndexPath *)indexPath {
	return NO;
}

- (BOOL)collectionView:(UICollectionView *)collectionView canPerformAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	return NO;
}

- (void)collectionView:(UICollectionView *)collectionView performAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	
}
*/

@end
