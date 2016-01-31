//
//  KHHomeImageCollectionViewCell.m
//  ImageX
//
//  Created by ZALORA on 1/27/16.
//  Copyright © 2016 KH. All rights reserved.
//

#import "KHHomeImageCollectionViewCell.h"

@interface KHHomeImageCollectionViewCell()

@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@end

@implementation KHHomeImageCollectionViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)configWithData:(KHPhoto *)photo {
    NSString *urlStr = [photo.arrSizes firstObject][@"https_url"];
    [self.imageView sd_setImageWithURL:[NSURL URLWithString:urlStr]];
}

@end
