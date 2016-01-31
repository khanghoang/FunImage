//
//  KHPhoto.h
//  ImageX
//
//  Created by ZALORA on 1/31/16.
//  Copyright © 2016 KH. All rights reserved.
//

#import <Mantle/Mantle.h>
#import "KHUser.h"

@interface KHPhoto : MTLModel
<
MTLJSONSerializing
>

@property (copy, nonatomic) NSNumber *imageID;
@property (copy, nonatomic) NSDate *createdAt;
@property (copy, nonatomic) NSString *imageDescription;
@property (copy, nonatomic) NSArray *arrSizes;
@property (copy, nonatomic) NSString *name;
@property (strong, nonatomic) KHUser *user;

- (NSString *)getCreatedAtDisplayString;

@end
