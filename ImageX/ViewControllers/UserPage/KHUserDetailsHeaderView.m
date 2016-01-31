//
//  KHUserDetailsHeaderView.m
//  ImageX
//
//  Created by ZALORA on 1/31/16.
//  Copyright © 2016 KH. All rights reserved.
//

#import "KHUserDetailsHeaderView.h"

@interface KHUserDetailsHeaderView()

@property (weak, nonatomic) IBOutlet UIImageView *coverImage;
@property (weak, nonatomic) IBOutlet UIView *wrapUserAvatarImage;
@property (weak, nonatomic) IBOutlet UIImageView *userAvatar;
@property (weak, nonatomic) IBOutlet UILabel *usernameLabel;

@end

@implementation KHUserDetailsHeaderView

- (void)configWithUser:(KHUser *)user {
    [self.coverImage sd_setImageWithURL:user.coverImageURL];
    [self.userAvatar sd_setImageWithURL:user.avatarURL];
    self.usernameLabel.text = user.fullname;
}

@end
