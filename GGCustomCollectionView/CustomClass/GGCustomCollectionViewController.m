//
//  GGCustomCollectionViewController.m
//  GGCustomCollectionView
//
//  Created by echgg on 15/5/2.
//  Copyright (c) 2015年 echgg. All rights reserved.
//
#define CELLWIDTH (KSCREENWIDTH - 20)  / 3
#import "GGCustomCollectionViewController.h"
#import "GGCustomCollectionViewCell.h"
#import <MJRefresh.h>

@interface GGCustomCollectionViewController ()

@end

@implementation GGCustomCollectionViewController{
    GGGetPhotosDataViewController *imageViewController;
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
    [_showDataInfoArray addObjectsFromArray:_showDataInfoArray];
    [self.collectionView reloadData];
    [self.collectionView.mj_footer endRefreshing];
}

-(void)initData
{
//    _showDataInfoArray = [[NSMutableArray alloc] init];
//    GGGetPhotosData *data = [GGGetPhotosData new];
    imageViewController = [[GGGetPhotosDataViewController alloc] init];
    [imageViewController getPhonePhotos];
    imageViewController.delegate = self;
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
    __block UIImage* thumbnail;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        ALAsset *asset =  (ALAsset*)[_showDataInfoArray objectAtIndex:indexPath.row];
        thumbnail = [[UIImage alloc] initWithCGImage:[[asset defaultRepresentation] fullScreenImage] scale:UIViewContentModeScaleAspectFit orientation:UIImageOrientationUp];
        dispatch_async(dispatch_get_main_queue(), ^{
            cell.myImage.image = thumbnail;
        });
    });

//    ALAssetRepresentation *rep = [asset defaultRepresentation];
//    Byte *buffer = (Byte*)malloc(rep.size);
//    NSUInteger buffered = [rep getBytes:buffer fromOffset:0.0 length:rep.size error:nil];
//    NSData *data = [NSData dataWithBytesNoCopy:buffer length:buffered freeWhenDone:YES];
//    cell.myImage.image = [_showDataInfoArray objectAtIndex:indexPath.row];
    cell.nameLabel.text = @"hello";
    // Configure the cell
    
    return cell;
}

#pragma mark <UICollectionViewDelegate>
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"cell's index is %d", indexPath.row + indexPath.section * 10);
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
