//
//  AppDelegate.h
//  BixGame
//
//  Created by Nikola Kotarov on 5/3/13.
//  Copyright (c) 2013 Nikola Kotarov. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (nonatomic, retain) NSMutableDictionary *notificationData;
@property (retain, nonatomic) Network *network;
@property (assign, nonatomic) BOOL isStarted;
@property (retain, nonatomic) NSString *deviceToken;

@end
