//
//  ViewController.m
//  ImageX
//
//  Created by ZALORA on 1/27/16.
//  Copyright © 2016 KH. All rights reserved.
//

#import "ViewController.h"
#import "KHHomeImageCollectionViewCell.h"

@interface ViewController ()
<
UICollectionViewDelegate,
UICollectionViewDataSource,
UICollectionViewDelegateFlowLayout
>

@property (copy, nonatomic) NSArray *popularImages;
@property (copy, nonatomic) NSArray *featureImages;

@property (weak, nonatomic) IBOutlet UICollectionView *collectionImage;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.popularImages = @[];
    self.featureImages = @[];
    
//    [self.collectionImage registerClass:[KHHomeImageCollectionViewCell class]
//             forCellWithReuseIdentifier:@"KHHomeImageCell"];
    
    [self.collectionImage registerNib:[UINib nibWithNibName:@"KHHomeImageCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"KHHomeImageCell"];
    
    
    __block typeof(self) weakSelf = self;
    [PXRequest authenticateWithUserName:USERNAME
                               password:PASSWORD
                             completion: ^(BOOL success) {
                                 if (success) {
                                     [PXRequest requestForPhotoFeature:PXAPIHelperPhotoFeaturePopular
                                                        resultsPerPage:20
                                                                  page:1
                                                            completion: ^(NSDictionary *results, NSError *error) {
                                                                weakSelf.popularImages = results[@"photos"];
                                                                [weakSelf.collectionImage reloadData];
                                                            }];
                                     
                                 }
                                 else {
                                     
                                 }
                             }];
    
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    KHHomeImageCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"KHHomeImageCell"
                                                                           forIndexPath:indexPath];
    NSDictionary *data = self.popularImages[indexPath.row];
    [cell configWithData:data];
    return cell;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.popularImages.count;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat dim = ([UIScreen mainScreen].bounds.size.width - 20 - 10) / 2;
    return CGSizeMake(dim, dim);
}

@end
