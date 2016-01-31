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

#define PER_PAGE 30

@interface ViewController ()
<
UICollectionViewDelegate,
UICollectionViewDataSource,
UICollectionViewDelegateFlowLayout
>

@property (copy, nonatomic) NSArray *popularImages;
@property (copy, nonatomic) NSArray *featureImages;

@property (assign, nonatomic) NSInteger currentPage;
@property (assign, nonatomic) BOOL hasNextPage;
@property (assign, nonatomic) BOOL isFetching;

@property (weak, nonatomic) IBOutlet UICollectionView *collectionImage;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.popularImages = @[];
    self.featureImages = @[];
    self.currentPage = 0;
    self.hasNextPage = YES;
    
    [self.collectionImage registerNib:[UINib nibWithNibName:@"KHHomeImageCollectionViewCell" bundle:nil]
           forCellWithReuseIdentifier:@"KHHomeImageCell"];
    [self loadImages];
}

- (void)loadImages {
    if (!self.hasNextPage) {
        return;
    }
    
    if (self.isFetching) {
        return;
    }
    
    self.isFetching = YES;
    
    __block typeof(self) weakSelf = self;
    [self loadPage:++self.currentPage
          withType:self.type
      successBlock:^(NSDictionary *results) {
          
          NSArray *photos = results[@"photos"];
          
          weakSelf.popularImages = [weakSelf.popularImages arrayByAddingObjectsFromArray:photos];
          [weakSelf.collectionImage reloadData];
          weakSelf.isFetching = NO;
          
          if (photos.count < PER_PAGE) {
              weakSelf.hasNextPage = NO;
          }
          
      } failureBlock:^(NSError *error) {
          weakSelf.isFetching = NO;
      }];
}

- (void)loadPage:(NSInteger)page withType:(PXAPIHelperPhotoFeature)type successBlock:(void (^)(NSDictionary *results))successBlock failureBlock:(void (^)(NSError *error))failureBlock {
    [PXRequest requestForPhotoFeature:type
                       resultsPerPage:PER_PAGE
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

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.popularImages.count ?: 30;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat dim = ([UIScreen mainScreen].bounds.size.width - 12 - 12) / 3;
    return CGSizeMake(dim, dim);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    KHDetailsViewController *details = [[UIStoryboard storyboardWithName:@"KHDetailsStoryboard" bundle:nil] instantiateViewControllerWithIdentifier:@"KHDetailsViewController"];
    details.hidesBottomBarWhenPushed = YES;
    if (self.popularImages.count > 0) {
        details.image = self.popularImages[indexPath.row];
        [self.navigationController pushViewController:details animated:YES];
    }
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section {
    if (!self.hasNextPage) return CGSizeZero;
    return CGSizeMake(self.view.bounds.size.width, 20);
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    if (kind == UICollectionElementKindSectionFooter) {
        UICollectionReusableView *footerview = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"LoadMoreFooterView" forIndexPath:indexPath];
        [self loadImages];
        return footerview;
    }
    return nil;
}

@end
