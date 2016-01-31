//
//  KHDateFormatterManager.m
//  ImageX
//
//  Created by ZALORA on 1/30/16.
//  Copyright © 2016 KH. All rights reserved.
//

#import "KHDateFormatterManager.h"

@interface KHDateFormatterManager()

@property (strong, nonatomic) NSDateFormatter *formatter;
@property (strong, nonatomic) NSDateFormatter *displayFormatter;

@end

@implementation KHDateFormatterManager

+ (instancetype)sharedInstance {
    
    static KHDateFormatterManager *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[KHDateFormatterManager alloc] init];
    });
    return instance;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        _formatter = [[NSDateFormatter alloc] init];
        _formatter.dateFormat = @"yyyy-MM-dd'T'HH:mm:ssZZZZZ";
        
        _displayFormatter = [[NSDateFormatter alloc] init];
        _displayFormatter.dateFormat = @"EEE, dd MMM yyyy";
    }
    
    return self;
}

@end
