//
//  User.h
//  twitter
//
//  Created by Ali YAZDAN PANAH on 10/28/14.
//  Copyright (c) 2014 Ali YAZDAN PANAH. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface User : NSObject

@property (nonatomic,strong) NSString *name;
@property (nonatomic,strong) NSString *screenName;
@property (nonatomic,strong) NSString *profileImageUrl;
@property (nonatomic,strong) NSString *tagline;

- (id)initWithDictionary:(NSDictionary *)dictionary;

@end
