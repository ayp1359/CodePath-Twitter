//
//  AppDelegate.m
//  twitter
//
//  Created by Ali YAZDAN PANAH on 10/27/14.
//  Copyright (c) 2014 Ali YAZDAN PANAH. All rights reserved.
//

#import "AppDelegate.h"
#import "SignInViewController.h"
#import "TwitterClient.h"
#import "User.h"
#import "Tweet.h"
#import "TimelineViewController.h"

@interface AppDelegate ()
@property (nonatomic, strong) UIViewController* signInViewController;
@property (nonatomic, strong) UIViewController* MainViewController;
@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
  
  User *user  = [User currentUser];
  
  self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
  self.signInViewController = [[SignInViewController alloc] init];
  
  if(!_MainViewController){
    _MainViewController = [[TimelineViewController alloc] initWithDataLoadingBlockWithSuccessFailure:^(void (^success)(NSArray *), void (^failure)(NSError *)) {
      [[TwitterClient instance] homeTimelineWithSuccess:success failure:failure];
    }];
  }
  
  if(user !=nil){
    _MainViewController.title = @"Home";
    self.window.rootViewController = [[UINavigationController alloc] initWithRootViewController:_MainViewController];
  }
  else{
    self.window.rootViewController = self.signInViewController;
  }
  
  [self registerUserNotifications];
  self.window.backgroundColor = [UIColor whiteColor];
  [self.window makeKeyAndVisible];
  
  return YES;
}


- (void) registerUserNotifications
{
  [[NSNotificationCenter defaultCenter] addObserverForName:CurrentUserSetNotification object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification *notification) {
    self.window.rootViewController = _MainViewController;
  }];
  
  [[NSNotificationCenter defaultCenter] addObserverForName:CurrentUserRemovedNotification object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification *notification) {
    self.window.rootViewController = self.signInViewController ;
  }];
}


- (void)applicationWillResignActive:(UIApplication *)application {
  // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
  // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
  // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
  // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
  // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
  // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
  // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation{
  
  [[NSNotificationCenter defaultCenter] postNotification:[NSNotification notificationWithName:kTwitterClientCallbackNotification object:nil userInfo:[NSDictionary dictionaryWithObject:url forKey:kTwitterClientCallbackURLKey]]];
  
  return YES;
}

@end
