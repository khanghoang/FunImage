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
    
    // set main image
    [self.mainImage sd_setImageWithURL:[NSURL URLWithString:[self.image[@"image_url"] firstObject]]];
    [self.userAvatar sd_setImageWithURL:self.image[@"user"][@"avatars"][@"default"][@"https"]];
    self.usernameLabel.text = self.image[@"user"][@"fullname"];
    
    // round the avatar
    self.userAvatar.layer.cornerRadius = 20;
    self.userAvatar.layer.masksToBounds = YES;
    
    // format the createTime
    NSDate *createdAt = [[KHDateFormatterManager sharedInstance].formatter dateFromString:self.image[@"created_at"]];
    self.datetimeLabel.text = [self displayCreatedTime:createdAt];
    
    self.textViewDescription.text = @"dummy description";
    
    // adjust the height of the desciption
    CGSize sizeThatFitsTextView = [self.textViewDescription sizeThatFits:CGSizeMake(self.textViewDescription.frame.size.width, MAXFLOAT)];
    self.descriptionHeightConstrant.constant = sizeThatFitsTextView.height;
}

- (NSString *)displayCreatedTime:(NSDate *)date {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"EEE, dd MMM yyyy";
    return [formatter stringFromDate:date];
}

- (void)onUserView {
    NSLog(@"Tap");
    
    KHUserPageViewController *userPage = [[KHUserPageViewController alloc] init];
    userPage.userID = self.image[@"user"][@"id"];
    [self.navigationController pushViewController:userPage animated:YES];
}

@end
