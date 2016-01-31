//
//  KHPhoto.m
//  ImageX
//
//  Created by ZALORA on 1/31/16.
//  Copyright © 2016 KH. All rights reserved.
//

#import "KHPhoto.h"
#import "KHDateFormatterManager.h"

@implementation KHPhoto

+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    return @{
             @"imageDescription": @"description",
             @"imageID": @"id",
             @"createdAt": @"created_at",
             @"name": @"name",
             @"user": @"user",
             @"arrSizes": @"images",
             };
}

+ (NSValueTransformer *)userJSONTransformer
{
    return [MTLJSONAdapter dictionaryTransformerWithModelClass:[KHUser class]];
}


+ (NSValueTransformer *)createdAtJSONTransformer
{
    return [MTLValueTransformer transformerUsingForwardBlock:^id(NSString *dateString, BOOL *success, NSError *__autoreleasing *error) {
        NSDateFormatter *formatter = [KHDateFormatterManager sharedInstance].formatter;
        return [formatter dateFromString:dateString];
    } reverseBlock:^id(NSDate *date, BOOL *success, NSError *__autoreleasing *error) {
        return [date description];
    }];
}

- (NSString *)getCreatedAtDisplayString {
    return [[KHDateFormatterManager sharedInstance].displayFormatter stringFromDate:self.createdAt];
}

@end
