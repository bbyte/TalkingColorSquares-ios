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
                                  @"NumbersAndColors",
                                  nil];
    sharedInstance = [[self alloc] initWithProductIdentifiers:productIdentifiers];
  });
  return sharedInstance;
}


@end
