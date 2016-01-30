//
//  KHUserPageViewController.m
//  ImageX
//
//  Created by ZALORA on 1/30/16.
//  Copyright © 2016 KH. All rights reserved.
//

#import "KHUserPageViewController.h"

@interface KHUserPageViewController ()

@end

@implementation KHUserPageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [PXRequest requestForPhotosOfUserID:[self.userID integerValue]
                             completion:^(NSDictionary *results, NSError *error) {
                                 
                                 
                                 
                             }];
}

@end
