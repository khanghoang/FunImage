//
//  KHUserPageViewController.h
//  ImageX
//
//  Created by ZALORA on 1/30/16.
//  Copyright © 2016 KH. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface KHUserPageViewController : UIViewController

@property (strong, nonatomic) NSNumber *userID;
@property (strong, nonatomic) NSURL *userAvatarURL;
@property (strong, nonatomic) NSString *username;

@end
