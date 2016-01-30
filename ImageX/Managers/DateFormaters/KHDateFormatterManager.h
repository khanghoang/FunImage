//
//  KHDateFormatterManager.h
//  ImageX
//
//  Created by ZALORA on 1/30/16.
//  Copyright © 2016 KH. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KHDateFormatterManager : NSObject

@property (readonly, nonatomic) NSDateFormatter *formatter;

+ (instancetype)sharedInstance;

@end
