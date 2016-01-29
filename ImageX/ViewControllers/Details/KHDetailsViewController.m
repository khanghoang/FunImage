//
//  KHDetailsViewController.m
//  ImageX
//
//  Created by ZALORA on 1/29/16.
//  Copyright © 2016 KH. All rights reserved.
//

#import "KHDetailsViewController.h"
#import "KHMainImageTableViewCell.h"

@interface KHDetailsViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *mainImage;
@property (weak, nonatomic) IBOutlet UIImageView *userAvatar;
@property (weak, nonatomic) IBOutlet UILabel *usernameLabel;

@property (weak, nonatomic) IBOutlet UIView *userView;
@property (weak, nonatomic) IBOutlet UITextView *textViewDescription;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *descriptionHeightConstrant;

@end

@implementation KHDetailsViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    UITapGestureRecognizer *tapOnUserView = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onUserView)];
    [self.userView addGestureRecognizer:tapOnUserView];
    
    [self.mainImage sd_setImageWithURL:[NSURL URLWithString:[self.image[@"image_url"] firstObject]]];
    [self.userAvatar sd_setImageWithURL:self.image[@"user"][@"avatars"][@"default"][@"https"]];
    self.usernameLabel.text = self.image[@"user"][@"fullname"];
    
    self.userAvatar.layer.cornerRadius = 20;
    self.userAvatar.layer.masksToBounds = YES;
    
    
//    self.textViewDescription.text = self.image[@"description"];
    self.textViewDescription.text = @"dummy description";
    CGSize sizeThatFitsTextView = [self.textViewDescription sizeThatFits:CGSizeMake(self.textViewDescription.frame.size.width, MAXFLOAT)];
    self.descriptionHeightConstrant.constant = sizeThatFitsTextView.height;
}

- (void)onUserView {
    NSLog(@"Tap");
}

@end
