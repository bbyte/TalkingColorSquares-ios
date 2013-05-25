//
//  ColorIAPHelper.m
//  BixGame
//
//  Created by Nikola Kotarov on 5/26/13.
//  Copyright (c) 2013 Nikola Kotarov. All rights reserved.
//

#import "ColorIAPHelper.h"

@implementation ColorIAPHelper

+ (ColorIAPHelper *) sharedInstance
{
  
  static dispatch_once_t once;
  static ColorIAPHelper *sharedInstance;
  dispatch_once(&once, ^{
    NSSet * productIdentifiers = [NSSet setWithObjects:
                                  @"com.razeware.inapprage.drummerrage",
                                  @"com.razeware.inapprage.itunesconnectrage",
                                  @"com.razeware.inapprage.nightlyrage",
                                  @"com.razeware.inapprage.studylikeaboss",
                                  @"com.razeware.inapprage.updogsadness",
                                  nil];
    sharedInstance = [[self alloc] initWithProductIdentifiers:productIdentifiers];
  });
  return sharedInstance;
}


@end
