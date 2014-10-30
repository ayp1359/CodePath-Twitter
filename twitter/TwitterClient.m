//
//  TwitterClient.m
//  twitter
//
//  Created by Ali YAZDAN PANAH on 10/27/14.
//  Copyright (c) 2014 Ali YAZDAN PANAH. All rights reserved.
//

#import "TwitterClient.h"
#import "Tweet.h"

NSString * const kTwitterConsumerKey = @"KC10IUWkp4ObmCQ0ReAlPB5W1";
NSString * const kTwitterConsumerSecret = @"IhCgHTlixnRrnt8lopcCGvlO3Hgy0lDoWtO7HJoyyKhRSiTxJO";
NSString * const kTwitterBaseUrl = @"https://api.twitter.com";

@interface TwitterClient()
@property (nonatomic,strong) void (^loginCompletion)(User *user, NSError *error);
@end

@implementation TwitterClient

+ (TwitterClient *)sharedInstance{
  static TwitterClient *instance = nil;
  static dispatch_once_t onceToken;
  
  dispatch_once(&onceToken, ^{
    if(instance==nil) {
      instance = [[TwitterClient alloc] initWithBaseURL:[NSURL URLWithString:kTwitterBaseUrl] consumerKey:kTwitterConsumerKey consumerSecret:kTwitterConsumerSecret];
    }
  });
  
  return instance;
}

- (void) loginWithCompletion:(void (^)(User *user, NSError *error))completion{
  
  self.loginCompletion = completion;
  
  [self.requestSerializer removeAccessToken];
  [self fetchRequestTokenWithPath:@"oauth/request_token" method:@"GET" callbackURL:[NSURL URLWithString:@"cptwitterdemo://oauth"] scope:nil success:^(BDBOAuthToken *requestToken) {
    //NSLog(@"got the token");
    
    NSURL *authURL = [NSURL URLWithString:[NSString stringWithFormat:@"https://api.twitter.com/oauth/authorize?oauth_token=%@",requestToken.token]];
    
    [[UIApplication sharedApplication] openURL:authURL];
    
  } failure:^(NSError *error) {
    self.loginCompletion(nil,error);
  }];
  
}

- (void)openURL:(NSURL *)url{
  
  [self fetchAccessTokenWithPath:@"oauth/access_token" method:@"POST" requestToken:[BDBOAuthToken tokenWithQueryString:url.query] success:^(BDBOAuthToken *accessToken) {
    
    //NSLog(@"got the token");
    [self.requestSerializer saveAccessToken:accessToken];
    
    [self GET:@"/1.1/account/verify_credentials.json" parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
      
      User *user  = [[User alloc] initWithDictionary:responseObject];
      [User setCurrentUser:user];
      
      self.loginCompletion (user,nil);
      
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
      NSLog(@"failed to get current user");
      self.loginCompletion(nil,error);
    }];
    
  } failure:^(NSError *error) {
    NSLog(@"failed to get token");
  }];
}

- (void)homeTimelineWithParams:(NSDictionary *)params completion:(void (^)(NSArray *tweets, NSError *error))completion{
  [self GET:@"1.1/statuses/home_timeline.json" parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
    NSArray *tweets = [Tweet tweetsWithArray:responseObject];
    completion(tweets,nil);
  } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
    completion(nil,error);
  }];
  
}


@end
