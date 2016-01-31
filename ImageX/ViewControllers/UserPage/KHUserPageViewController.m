//
//  KHUserPageViewController.m
//  ImageX
//
//  Created by ZALORA on 1/30/16.
//  Copyright © 2016 KH. All rights reserved.
//

#import "KHUserPageViewController.h"
#import "KHHomeImageCollectionViewCell.h"
#import "KHUserDetailsHeaderView.h"
#import "KHDetailsViewController.h"
#import "KHLoadMoreFooterView.h"

#define PER_PAGE 20

@interface KHUserPageViewController ()
<
UICollectionViewDelegate,
UICollectionViewDelegateFlowLayout,
UICollectionViewDataSource
>

@property (weak, nonatomic) IBOutlet UICollectionView *collectionViewImages;
@property (strong, nonatomic) NSArray *arrPhotos;
@property (assign, nonatomic) BOOL hasNextPage;
@property (assign, nonatomic) BOOL isFetching;
@property (assign, nonatomic) NSInteger currentPage;

@end

@implementation KHUserPageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.hasNextPage = YES;
    self.currentPage = 0;
    self.arrPhotos = @[];
    
    self.navigationController.title = self.username;
    
    [self.collectionViewImages registerNib:[UINib nibWithNibName:@"KHUserDetailsHeaderView" bundle:nil]
                forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"KHUserDetailsHeaderView"];
    [self.collectionViewImages registerNib:[UINib nibWithNibName:@"KHLoadMoreFooterView" bundle:nil]
                forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"KHLoadMoreFooterView"];
    [self.collectionViewImages registerNib:[UINib nibWithNibName:@"KHHomeImageCollectionViewCell" bundle:nil]
                forCellWithReuseIdentifier:@"KHHomeImageCell"];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self addObserver:self
           forKeyPath:@"arrPhotos"
              options:NSKeyValueObservingOptionNew
              context:0];
    [self addObserver:self
           forKeyPath:@"hasNextPage"
              options:NSKeyValueObservingOptionNew
              context:0];
    
    [self loadImages];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self removeObserver:self forKeyPath:@"arrPhotos"];
    [self removeObserver:self forKeyPath:@"hasNextPage"];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context {
    if ([keyPath isEqualToString:@"arrPhotos"]) {
        [self.collectionViewImages reloadData];
        return;
    }
    
    if ([keyPath isEqualToString:@"hasNextPage"]) {
        [self.collectionViewImages reloadData];
        return;
    }
    
    return;
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
      successBlock:^(NSDictionary *results) {
          
          NSArray *photos = results[@"photos"];
          
          weakSelf.arrPhotos = [weakSelf.arrPhotos arrayByAddingObjectsFromArray:photos];
          weakSelf.isFetching = NO;
          
          NSInteger totalPage = -1;
          if (results[@"total_pages"]) {
              totalPage = [results[@"total_pages"] integerValue];
          }
          
          if (totalPage <= weakSelf.currentPage || totalPage == -1) {
              weakSelf.hasNextPage = NO;
          }
          
      } failureBlock:^(NSError *error) {
          weakSelf.isFetching = NO;
      }];
}

- (void)loadPage:(NSInteger)page successBlock:(void (^)(NSDictionary *results))successBlock failureBlock:(void (^)(NSError *error))failureBlock {
    [PXRequest requestForPhotosOfUserID:[self.userID integerValue] userFeature:PXAPIHelperUserPhotoFeaturePhotos resultsPerPage:PER_PAGE page:page photoSizes:kPXAPIHelperDefaultPhotoSize completion:^(NSDictionary *results, NSError *error) {
        if (error && failureBlock) {
            failureBlock(error);
        }
        else if (!error && successBlock) {
            successBlock(results);
        }
    }];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    KHHomeImageCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"KHHomeImageCell" forIndexPath:indexPath];
    if (self.arrPhotos.count == 0) {
        return cell;
    }
    
    [cell configWithData:self.arrPhotos[indexPath.row]];
    return cell;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.arrPhotos.count ?: 20;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    if (kind == UICollectionElementKindSectionHeader) {
        KHUserDetailsHeaderView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"KHUserDetailsHeaderView" forIndexPath:indexPath];
        
        [headerView configWithData:nil];
        
        return headerView;
    }
    
    if (kind == UICollectionElementKindSectionFooter) {
        KHLoadMoreFooterView *footerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"KHLoadMoreFooterView" forIndexPath:indexPath];
        [self loadImages];
        return footerView;
    }
    
    return nil;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    CGFloat ratio = 266.0 / 320;
    return CGSizeMake(width, width * ratio);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section {
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    if (self.hasNextPage) {
        return CGSizeMake(screenWidth, 30);
    }
    return CGSizeZero;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    NSInteger numberOfPhotosPerRow = 3;
    CGFloat margin = 2;
    
    CGFloat width = (screenWidth - ((numberOfPhotosPerRow - 1) * margin)) / numberOfPhotosPerRow;
    
    return CGSizeMake(width, width);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    KHDetailsViewController *details = [[UIStoryboard storyboardWithName:@"KHDetailsStoryboard" bundle:nil] instantiateViewControllerWithIdentifier:@"KHDetailsViewController"];
    if (self.arrPhotos.count > 0) {
        details.image = self.arrPhotos[indexPath.row];
        [self.navigationController pushViewController:details animated:YES];
    }
}


@end
