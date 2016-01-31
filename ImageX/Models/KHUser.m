//
//  KHUser.m
//  ImageX
//
//  Created by ZALORA on 1/31/16.
//  Copyright © 2016 KH. All rights reserved.
//

#import "KHUser.h"

@interface KHUser()
<
MTLJSONSerializing
>

@end

@implementation KHUser

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
        @"userID": @"id",
        @"fullname": @"fullname",
        @"avatarURL": @"avatars.default.https",
        @"coverImageURL": @"cover_url",
        };
}

+ (NSValueTransformer *)coverImageURLJSONTransformer {
    return [NSValueTransformer valueTransformerForName:MTLURLValueTransformerName];
}

+ (NSValueTransformer *)avatarURLJSONTransformer {
    return [NSValueTransformer valueTransformerForName:MTLURLValueTransformerName];
}

@end
