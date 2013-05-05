//
//  MainViewController.m
//  BixGame
//
//  Created by Nikola Kotarov on 5/3/13.
//  Copyright (c) 2013 Nikola Kotarov. All rights reserved.
//

#import "ColorViewController.h"
#import <QuartzCore/QuartzCore.h>
#import <AudioToolbox/AudioToolbox.h>
#import "UIButtonExtras.h"


#define randrange(N) rand() / (RAND_MAX/(N) + 1)

@interface ColorViewController ()

@end

@implementation ColorViewController

@synthesize buttons, selectButton, colors, numbers, mode, selectClickCounter;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
  self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
  if (self) {
    // Custom initialization
    
//    NSDictionary *orange, *yellow, *black, *blue, *brown, *gray, *green, *pink, *red, *white;
    
//    orange = [[NSDictionary alloc] initWithObjects: @"" forKeys: @[@"UIColor", @"Assigned"]];
    
    CAGradientLayer *orange, *yellow, *black, *blue, *brown, *gray, *green, *pink, *red, *white;
    
    orange = [CAGradientLayer layer];
    orange.colors = @[(id)[[UIColor blackColor] CGColor], (id)[[UIColor orangeColor] CGColor]];

    yellow = [CAGradientLayer layer];
    yellow.colors = @[(id)[[UIColor blackColor] CGColor], (id)[[UIColor yellowColor] CGColor], (id)[[UIColor yellowColor] CGColor], (id)[[UIColor yellowColor] CGColor]];

    black = [CAGradientLayer layer];
    black.colors = @[(id)[[UIColor blackColor] CGColor], (id)[[UIColor blackColor] CGColor]];

    blue = [CAGradientLayer layer];
//    blue.colors = @[(id)[[UIColor blackColor] CGColor], (id)[[UIColor blueColor] CGColor]];
    blue.colors = @[(id)[[UIColor colorWithRed: 30/255.0f green: 142/255.0f blue: 253/255.0f alpha: 1] CGColor],
                    (id)[[UIColor colorWithRed: 18/255.0f green: 87/255.0f blue: 155/255.0f alpha: 1] CGColor]];
    
    brown = [CAGradientLayer layer];
    brown.colors = @[(id)[[UIColor blackColor] CGColor], (id)[[UIColor brownColor] CGColor]];
    
    gray = [CAGradientLayer layer];
    gray.colors = @[(id)[[UIColor blackColor] CGColor], (id)[[UIColor grayColor] CGColor]];
    
    green = [CAGradientLayer layer];
    green.colors = @[(id)[[UIColor blackColor] CGColor], (id)[[UIColor greenColor] CGColor], (id)[[UIColor blackColor] CGColor]];
    
    pink = [CAGradientLayer layer];
//    pink.colors = @[(id)[[UIColor blackColor] CGColor], (id)[[UIColor purpleColor] CGColor]];
    pink.colors = @[(id)[[UIColor colorWithRed: 247/255.0f green: 120/255.0f blue: 160/255.0f alpha: 1] CGColor],
                    (id)[[UIColor colorWithRed: 247/255.0f green: 120/255.0f blue: 160/255.0f alpha: 1] CGColor]];
    
    red = [CAGradientLayer layer];
//    red.colors = @[(id)[[UIColor blackColor] CGColor], (id)[[UIColor redColor] CGColor]];
    red.colors = @[(id)[[UIColor colorWithRed: 215/255.0f green: 49/255.0f blue: 49/255.0f alpha: 1] CGColor],
                   (id)[[UIColor colorWithRed: 205/255.0f green: 2/255.0f blue: 2/255.0f alpha: 1] CGColor]];
    
    white = [CAGradientLayer layer];
    white.colors = @[(id)[[UIColor blackColor] CGColor], (id)[[UIColor whiteColor] CGColor]];

    colors = [[NSDictionary alloc] initWithObjects: @[orange, yellow, black, blue, brown, gray, green, pink, red, white]
                                           forKeys: @[@"Orange", @"Yellow", @"Black", @"Blue", @"Brown", @"Gray", @"Green", @"Pink", @"Red", @"White"]];
    // mode:
    // 1 for numbers
    // 2 for colors
    mode = 1;
    
    self.selectClickCounter = 0;
    [self playMP3File: @"hello"];
    
  }
  return self;
}

- (void) initColors
{
  int a[10], i, nvalues = 10;
  
	for(i = 0; i < nvalues; i++)
		a[i] = i + 1;
  
	for(i = 0; i < nvalues-1; i++) {
		int c = randrange(nvalues-i);
		int t = a[i]; a[i] = a[i+c]; a[i+c] = t;	/* swap */
	}
  
  
  for (UIButton *button in buttons) {
    for (UIView *subView in [button subviews]) {
      [subView removeFromSuperview];
    }
  }
  
  i = 0;

  for (NSString *gradientType in [colors allKeys]) {
    
    UIButton *cButton = (UIButton *)self.buttons[a[i] - 1];
    CAGradientLayer *gradient = [colors objectForKey: gradientType];
    
    if (self.mode == 1){
      
      UILabel *number = [[UILabel alloc] initWithFrame: cButton.bounds];
      number.textAlignment = UITextAlignmentCenter;
      number.font = [UIFont boldSystemFontOfSize: 48];
      number.text = [NSString stringWithFormat: @"%d", i + 1];
      if ([gradientType isEqualToString: @"White"]) {
        number.textColor = [UIColor blackColor];
      } else {
        number.textColor = [UIColor whiteColor];
      }
      number.backgroundColor = [UIColor clearColor];
      [cButton addSubview: number];
    }
      
    gradient.frame = cButton.bounds;
    [[cButton layer] insertSublayer: gradient atIndex:0];
    [[cButton layer] setCornerRadius: 8.0f];
    [[cButton layer] setMasksToBounds: YES];
    
    cButton.tag = i + 1;
    cButton.cColor = gradientType;
    
    i++;
  }
}

- (void)viewDidLoad
{
  [super viewDidLoad];
  // Do any additional setup after loading the view from its nib.
  
  [self.selectButton setImage: [UIImage imageNamed: [NSString stringWithFormat: @"game-%d", self.mode]]
                     forState: UIControlStateNormal];

  
  [self initColors];
}

- (IBAction) buttonClicked:(id)sender
{
  if (self.mode == 1) {
    
  
  [self playMP3File: [NSString stringWithFormat: @"%d", [sender tag]]];

  } else {
    
    [self playMP3File: [NSString stringWithFormat: @"%@", [sender cColor]]];
  }

  [UIView transitionWithView: sender
                    duration: 1.0
                     options: UIViewAnimationOptionTransitionFlipFromLeft
                  animations: nil
                  completion: NULL];

}

- (IBAction) selectButtonClicked:(id)sender
{
  
  if (self.selectClickCounter < 3) {
  
    switch (self.mode) {
      case 1:
        [self.selectButton setImage: [UIImage imageNamed: @"game-2"] forState: UIControlStateNormal];
        self.mode = 2;
        
        break;
        
      case 2:
        [self.selectButton setImage: [UIImage imageNamed: @"game-1"] forState: UIControlStateNormal];
        self.mode = 1;
        break;
        
      default:
        break;
    }
    
    [UIView transitionWithView: self.view
                      duration: 1.0
                       options: UIViewAnimationOptionTransitionFlipFromLeft
                    animations: ^(void) { [self playMP3File: [NSString stringWithFormat: @"%d-voice", self.mode]]; [self initColors]; }
                    completion: nil];
  
    self.selectClickCounter++;
  } else {
    
    [self playMP3File: @"numbers-song"];
    self.selectClickCounter = 0;
  }
}


- (NSString *)mp3File: (NSString *) number
{
  // MARK: Get the filename of the sound file:
  NSString *path = [NSString stringWithFormat:@"%@/%@.mp3", [[NSBundle mainBundle] resourcePath],
                    number];
  return path;
}

- (void) playMP3File: (NSString *) number
{
  
  NSString *path;
  path = [self mp3File: number];
  
	//declare a system sound
	// id SystemSoundID soundID;
  
  SystemSoundID soundID;
  
  
	//Get a URL for the sound file
	NSURL *filePath = [NSURL fileURLWithPath:path isDirectory:NO];
  
	//Use audio sevices to create the sound
	AudioServicesCreateSystemSoundID((__bridge CFURLRef)filePath, &soundID);
	//Use audio services to play the sound
	AudioServicesPlaySystemSound(soundID);
}


- (void)didReceiveMemoryWarning
{
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

@end
