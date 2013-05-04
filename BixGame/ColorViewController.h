//
//  MainViewController.h
//  BixGame
//
//  Created by Nikola Kotarov on 5/3/13.
//  Copyright (c) 2013 Nikola Kotarov. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ColorViewController : UIViewController

@property (retain, nonatomic) IBOutletCollection(UIButton) NSArray *buttons;
@property (retain, nonatomic) IBOutlet UIButton *selectButton;
@property (retain, nonatomic) NSDictionary *colors, *numbers;
@property (assign, nonatomic) int mode;
@property (assign, nonatomic) int selectClickCounter;


- (IBAction) buttonClicked:(id)sender;
- (IBAction) selectButtonClicked:(id)sender;

- (NSString *)mp3File: (NSString *) number;
- (void) playMP3File: (NSString *) number;

@end
