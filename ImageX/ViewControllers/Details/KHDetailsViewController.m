//
//  KHDetailsViewController.m
//  ImageX
//
//  Created by ZALORA on 1/29/16.
//  Copyright © 2016 KH. All rights reserved.
//

#import "KHDetailsViewController.h"
#import "KHMainImageTableViewCell.h"
#import "KHUserPageViewController.h"

@interface KHDetailsViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *mainImage;
@property (weak, nonatomic) IBOutlet UIImageView *userAvatar;
@property (weak, nonatomic) IBOutlet UILabel *usernameLabel;
@property (weak, nonatomic) IBOutlet UILabel *datetimeLabel;

@property (weak, nonatomic) IBOutlet UIView *userView;
@property (weak, nonatomic) IBOutlet UITextView *textViewDescription;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *descriptionHeightConstrant;

@end

@implementation KHDetailsViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    // add guesture to userview
    UITapGestureRecognizer *tapOnUserView = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onUserView)];
    [self.userView addGestureRecognizer:tapOnUserView];
    
    self.navigationItem.title = self.photo.name;
    
    // set main image
    [self.mainImage sd_setImageWithURL:[NSURL URLWithString:[self.photo.arrSizes firstObject][@"https_url"]]];
    [self.userAvatar sd_setImageWithURL:self.photo.user.avatarURL];
    self.usernameLabel.text = self.photo.user.fullname;
    
    // format the createTime
    self.datetimeLabel.text = self.photo.getCreatedAtDisplayString;
    
    self.textViewDescription.text = self.photo.imageDescription;
    
    // adjust the height of the desciption
    CGSize sizeThatFitsTextView = [self.textViewDescription sizeThatFits:CGSizeMake(self.textViewDescription.frame.size.width, MAXFLOAT)];
    self.descriptionHeightConstrant.constant = sizeThatFitsTextView.height;
}

- (void)onUserView {
    KHUserPageViewController *userPage = [[KHUserPageViewController alloc] init];
    userPage.user = self.photo.user;
    [self.navigationController pushViewController:userPage animated:YES];
}

@end
