//
//  AppDelegate.m
//  BixGame
//
//  Created by Nikola Kotarov on 5/3/13.
//  Copyright (c) 2013 Nikola Kotarov. All rights reserved.
//

#import "AppDelegate.h"
#import "ColorViewController.h"

@implementation AppDelegate

@synthesize notificationData;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
  [NewRelicAgent startWithApplicationToken:@"AAdd44c7f09fd4426eec76c18d9768758bea1ca8ac"];
  self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
  // Override point for customization after application launch.
  
  
  // Let the device know we want to receive push notifications
  [[UIApplication sharedApplication] registerForRemoteNotificationTypes:
   (UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound | UIRemoteNotificationTypeAlert)];
  
  self.notificationData = [launchOptions objectForKey: UIApplicationLaunchOptionsRemoteNotificationKey];
  
  if(! self.notificationData && application.applicationIconBadgeNumber > 0){
    
    self.notificationData = [[NSMutableDictionary alloc] init];
    [self.notificationData setObject: @"YES" forKey: @"Notification"];
    NSLog(@"There is notification, and the app is started from phone, not from lock/notification");
  }

  
  ColorViewController *mainViewController = [[ColorViewController alloc] init];
  
  [self.window setRootViewController: mainViewController];
  
  self.window.backgroundColor = [UIColor blackColor];
  [self.window makeKeyAndVisible];
  return YES;
}

- (void)application:(UIApplication*)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData*)devToken
{
  
  // Prepare the Device Token for Registration (remove spaces and < >)
  NSString *deviceToken = [[[[devToken description]
                             stringByReplacingOccurrencesOfString: @"<" withString:@""]
                            stringByReplacingOccurrencesOfString: @">" withString:@""]
                           stringByReplacingOccurrencesOfString: @" " withString: @""];
  
//  [[[Global variable] device] setObject: deviceToken forKey: @"token"];
  
  NSLog(@"Generated token: %@", deviceToken);
//  NSLog(@"Here: %@", [[[Global variable] device] objectForKey: @"token"]);
}

/**
 * Remote Notification Received while application was open.
 */
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
  
  NSLog(@"remote notification: %@",[userInfo description]);
  NSDictionary *apsInfo = [userInfo objectForKey:@"aps"];
  
  NSDictionary *alert = [apsInfo objectForKey:@"alert"];
  NSLog(@"Received Push Alert: %@", alert);
  
  NSString *sound = [apsInfo objectForKey:@"sound"];
  NSLog(@"Received Push Sound: %@", sound);
  // AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
  
  // no need to add badge to icon when we are in the app
  //  NSString *badge = [apsInfo objectForKey:@"badge"];
  //  NSLog(@"Received Push Badge: %@", badge);
  //  application.applicationIconBadgeNumber = [[apsInfo objectForKey:@"badge"] integerValue];
  
  UIAlertView *alertMessage = [[UIAlertView alloc] initWithTitle: @"Notification"
                                                         message: [alert objectForKey: @"body"]
                                                        delegate: self
                                               cancelButtonTitle: @"Ok"
                                               otherButtonTitles: nil];
  alertMessage.tag = 769;
  [alertMessage show];
}


- (void)applicationWillResignActive:(UIApplication *)application
{
  // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
  // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
  // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
  // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
  // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
  // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
  // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
