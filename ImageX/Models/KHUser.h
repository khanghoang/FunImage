//
//  KHUser.h
//  ImageX
//
//  Created by ZALORA on 1/31/16.
//  Copyright © 2016 KH. All rights reserved.
//

#import <Mantle/Mantle.h>

@interface KHUser : MTLModel

@property (copy, nonatomic) NSURL *avatarURL;
@property (copy, nonatomic) NSString *fullname;
@property (copy, nonatomic) NSNumber *userID;
@property (copy, nonatomic) NSURL *coverImageURL;

@end
