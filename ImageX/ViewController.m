//
//  ViewController.m
//  ImageX
//
//  Created by ZALORA on 1/27/16.
//  Copyright © 2016 KH. All rights reserved.
//

#import "ViewController.h"
#import "KHHomeImageCollectionViewCell.h"
#import "KHDetailsViewController.h"

@interface ViewController ()
<
UICollectionViewDelegate,
UICollectionViewDataSource,
UICollectionViewDelegateFlowLayout
>

@property (copy, nonatomic) NSArray *popularImages;
@property (copy, nonatomic) NSArray *featureImages;

@property (assign, nonatomic) NSInteger currentPage;

@property (weak, nonatomic) IBOutlet UICollectionView *collectionImage;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.popularImages = @[];
    self.featureImages = @[];
    
    [self.collectionImage registerNib:[UINib nibWithNibName:@"KHHomeImageCollectionViewCell" bundle:nil]
           forCellWithReuseIdentifier:@"KHHomeImageCell"];
    
    __block typeof(self) weakSelf = self;
    
    [self loadPage:self.currentPage
          withType:PXAPIHelperPhotoFeaturePopular
      successBlock:^(NSDictionary *results) {
          weakSelf.popularImages = results[@"photos"];
          NSLog(@"%@", results[@"photos"]);
          [weakSelf.collectionImage reloadData];
      } failureBlock:^(NSError *error) {
      }];
    
}

- (void)loadPage:(NSInteger)page withType:(PXAPIHelperPhotoFeature)type successBlock:(void (^)(NSDictionary *results))successBlock failureBlock:(void (^)(NSError *error))failureBlock {
    [PXRequest authenticateWithUserName:USERNAME
                               password:PASSWORD
                             completion: ^(BOOL success) {
                                 if (success) {
                                     [PXRequest requestForPhotoFeature:type
                                                        resultsPerPage:30
                                                                  page:page
                                                            completion: ^(NSDictionary *results, NSError *error) {
                                                                if (error) {
                                                                    if (failureBlock) {
                                                                        failureBlock(error);
                                                                    }
                                                                } else {
                                                                    successBlock(results);
                                                                }
                                                            }];
                                     
                                 }
                                 else {
                                     
                                 }
                             }];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    KHHomeImageCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"KHHomeImageCell"
                                                                           forIndexPath:indexPath];
    NSDictionary *data = nil;
    if (self.popularImages.count > 0) {
        data = self.popularImages[indexPath.row];
    }
    [cell configWithData:data];
    return cell;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.popularImages.count ?: 30;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat dim = ([UIScreen mainScreen].bounds.size.width - 12 - 12) / 3;
    return CGSizeMake(dim, dim);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    KHDetailsViewController *details = [[UIStoryboard storyboardWithName:@"KHDetailsStoryboard" bundle:nil] instantiateViewControllerWithIdentifier:@"KHDetailsViewController"];
    if (self.popularImages.count > 0) {
        details.image = self.popularImages[indexPath.row];
        [self.navigationController pushViewController:details animated:YES];
    }
}

@end
