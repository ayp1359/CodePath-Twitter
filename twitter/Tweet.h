//
//  Tweet.h
//  twitter
//
//  Created by Ali YAZDAN PANAH on 10/28/14.
//  Copyright (c) 2014 Ali YAZDAN PANAH. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "User.h"

@interface Tweet : NSObject

@property (nonatomic,strong) NSString *text;
@property (nonatomic,strong) NSDate *createdAt;
@property (nonatomic,strong) User *user;

- (id)initWithDictionary:(NSDictionary *)dictionary;

+ (NSArray *)tweetsWithArray: (NSArray *)array;
@end
