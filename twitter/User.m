//
//  User.m
//  twitter
//
//  Created by Ali YAZDAN PANAH on 10/28/14.
//  Copyright (c) 2014 Ali YAZDAN PANAH. All rights reserved.
//

#import "User.h"

@implementation User

- (id)initWithDictionary:(NSDictionary *)dictionary{
  
  self = [super init];
  
  if(self){
    self.name  = dictionary[@"name"];
    self.screenName = dictionary[@"screen_name"];
    self.profileImageUrl = dictionary[@"profile_image_url"];
    self.tagline = dictionary[@"description"];
    
  }
  return self;
}

@end
