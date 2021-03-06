//
//  AppDelegate.m
//  BixGame
//
//  Created by Nikola Kotarov on 5/3/13.
//  Copyright (c) 2013 Nikola Kotarov. All rights reserved.
//

#import "AppDelegate.h"
#import "ColorViewController.h"
#import "ColorIAPHelper.h"


@implementation AppDelegate

@synthesize notificationData;
@synthesize network;
@synthesize isStarted;
@synthesize deviceToken;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
  self.isStarted = NO;
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
  
  self.network = [Network sharedInstance];

  [ColorIAPHelper sharedInstance];
  
  // first time start
  
  if (! [[NSUserDefaults standardUserDefaults] boolForKey: @"splashShowed"]){
    
    SEND_SETUP
  }
  
  
  ColorViewController *mainViewController = [[ColorViewController alloc] init];
  
  [self.window setRootViewController: mainViewController];
  
  self.window.backgroundColor = [UIColor blackColor];
  [self.window makeKeyAndVisible];
  
  SEND_EVENT_STARTED
  
  return YES;
}

- (void)application:(UIApplication*)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData*)devToken
{
  
  // Prepare the Device Token for Registration (remove spaces and < >)
  self.deviceToken = [[[[devToken description]
                             stringByReplacingOccurrencesOfString: @"<" withString:@""]
                            stringByReplacingOccurrencesOfString: @">" withString:@""]
                           stringByReplacingOccurrencesOfString: @" " withString: @""];
  
//  [[[Global variable] device] setObject: deviceToken forKey: @"token"];
  
  NSLog(@"Generated token: %@", self.deviceToken);
//  NSLog(@"Here: %@", [[[Global variable] device] objectForKey: @"token"]);
  
//  if (! [[NSUserDefaults standardUserDefaults] boolForKey: @"splashShowed"]){
  
    SEND_TOKEN_UPDATE(self.deviceToken);
//  }
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
//  SEND_EVENT_SUSPENDED
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
  // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
  // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
  
  SEND_EVENT_SUSPENDED
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
  // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
  // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
  
  if (! self.isStarted) {
    
    self.isStarted = YES;
  } else {
    
    SEND_EVENT_RESUMED
  }
}

- (void)applicationWillTerminate:(UIApplication *)application
{
  // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
//  SEND_EVENT_QUIT
}

@end
