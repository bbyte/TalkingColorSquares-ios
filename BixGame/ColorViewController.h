//
//  MainViewController.h
//  BixGame
//
//  Created by Nikola Kotarov on 5/3/13.
//  Copyright (c) 2013 Nikola Kotarov. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "UIImageExtras.h"

@interface ColorViewController : UIViewController

@property (retain, nonatomic) IBOutletCollection(UIButton) NSArray *buttons;
@property (retain, nonatomic) IBOutlet UIButton *selectButton, *notaButton, *randomButton, *buyButton;
@property (retain, nonatomic) NSDictionary *colors, *numbers;
@property (assign, nonatomic) int mode;
@property (assign, nonatomic) int selectClickCounter;
@property (retain, nonatomic) UIView *lockView;
@property (assign, nonatomic) BOOL isRandom;
@property (retain, nonatomic) NSArray *colorArrange;
@property (retain, nonatomic) NSArray *shapes;
@property (retain, nonatomic) NSDictionary *colorImages;

@property (retain, nonatomic) UISwipeGestureRecognizer *recognizer, *recognizer1;
@property (retain, nonatomic) CABasicAnimation *bumpAnimation;

@property (retain, nonatomic) Network *network;


- (IBAction) buttonClicked:(id)sender;
- (IBAction) selectButtonClicked:(id)sender;

- (IBAction) notaButtonClicked:(id)sender;
- (IBAction) randomButtonClicked:(id)sender;

- (IBAction) buyButtonClicked:(id)sender;


- (NSString *)mp3File: (NSString *) number;
- (void) playMP3File: (NSString *) number;

- (void) lockUI;
- (void) releaseUILock;

- (BOOL) isPaid;

@end
