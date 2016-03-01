//
//  GGGetPhotosDataViewController.m
//  GGCustomCollectionView
//
//  Created by echgg on 16/2/29.
//  Copyright © 2016年 echgg. All rights reserved.
//

#import "GGGetPhotosDataViewController.h"
static int count = 0;
@interface GGGetPhotosDataViewController ()

@end

@implementation GGGetPhotosDataViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)getPhonePhotos
{
    [self getAllPictures];
//    return imageArray;
}

-(void)getAllPictures
{
    imageArray=[[NSArray alloc] init];
    mutableArray =[[NSMutableArray alloc]init];
    NSMutableArray* assetURLDictionaries = [[NSMutableArray alloc] init];
    
    library = [[ALAssetsLibrary alloc] init];
    
    void (^assetEnumerator)( ALAsset *, NSUInteger, BOOL *) = ^(ALAsset *result, NSUInteger index, BOOL *stop) {
        if(result != nil) {
            if([[result valueForProperty:ALAssetPropertyType] isEqualToString:ALAssetTypePhoto]) {
                [assetURLDictionaries addObject:[result valueForProperty:ALAssetPropertyURLs]];
                
                NSURL *url= (NSURL*) [[result defaultRepresentation]url];
                
                [library assetForURL:url
                         resultBlock:^(ALAsset *asset) {
                             [mutableArray addObject:[UIImage imageWithCGImage:[[asset defaultRepresentation] fullScreenImage]]];
                             
                             if ([mutableArray count]==count)
                             {
                                 imageArray=[[NSArray alloc] initWithArray:mutableArray];
                                 [self allPhotosCollected:imageArray];
                             }
                         }
                        failureBlock:^(NSError *error){ NSLog(@"operation was not successfull!"); } ];
                
            }
        }
    };
    
    NSMutableArray *assetGroups = [[NSMutableArray alloc] init];
    
    void (^ assetGroupEnumerator) ( ALAssetsGroup *, BOOL *)= ^(ALAssetsGroup *group, BOOL *stop) {
        if(group != nil) {
            NSString *groupName = [group valueForProperty:ALAssetsGroupPropertyName];
            NSString *groupUrl = [group valueForProperty:ALAssetsGroupPropertyURL];
            NSLog(@"group name is %@, and group url is %@", groupName, groupUrl);
            [group enumerateAssetsUsingBlock:assetEnumerator];
            [assetGroups addObject:group];
            count=[group numberOfAssets];
        }
    };
    //用户拒绝访问
    void(^assetGroupEnumError)(NSError*) = ^(NSError *error){
        NSString *errorMsg = @"can not access library groups!";
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
                                                        message:errorMsg
                                                       delegate:self
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil, nil];
        [alert show];
    };
    
    assetGroups = [[NSMutableArray alloc] init];
    
    [library enumerateGroupsWithTypes:ALAssetsGroupAll
                           usingBlock:assetGroupEnumerator
                         failureBlock:assetGroupEnumError];
}

-(void)allPhotosCollected:(NSArray*)imgArray
{
    //write your code here after getting all the photos from library...
    NSLog(@"all pictures are %@",imgArray);
    if(self.delegate && [self.delegate respondsToSelector:@selector(getImageData:)])
    {
        [self.delegate getImageData:imageArray];
    }
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
