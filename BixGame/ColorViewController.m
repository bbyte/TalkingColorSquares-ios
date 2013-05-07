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
#define DEFAULT_UILOCKTIME 1.5f

@interface ColorViewController ()

@end

@implementation ColorViewController

@synthesize buttons, selectButton, colors, numbers, mode, selectClickCounter;
@synthesize lockView;
@synthesize randomButton, notaButton;
@synthesize recognizer, recognizer1;
@synthesize bumpAnimation;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
  self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
  if (self) {
    // Custom initialization
    
//    NSDictionary *orange, *yellow, *black, *blue, *brown, *gray, *green, *pink, *red, *white;
    
//    orange = [[NSDictionary alloc] initWithObjects: @"" forKeys: @[@"UIColor", @"Assigned"]];
    
    CAGradientLayer *orange, *yellow, *black, *blue, *brown, *gray, *green, *pink, *red, *white;
    
    orange = [CAGradientLayer layer];
//    orange.colors = @[(id)[[UIColor blackColor] CGColor], (id)[[UIColor orangeColor] CGColor]];
    orange.colors = @[(id)[[UIColor colorWithRed: 255/255.0f green: 128/255.0f blue: 0/255.0f alpha: 1] CGColor],
                      (id)[[UIColor colorWithRed: 255/255.0f green: 128/255.0f blue: 0/255.0f alpha: 1] CGColor]];
    
    yellow = [CAGradientLayer layer];
//    yellow.colors = @[(id)[[UIColor blackColor] CGColor], (id)[[UIColor yellowColor] CGColor], (id)[[UIColor yellowColor] CGColor], (id)[[UIColor yellowColor] CGColor]];

    yellow.colors = @[(id)[[UIColor colorWithRed: 255/255.0f green: 221/255.0f blue: 24/255.0f alpha: 1] CGColor],
                      (id)[[UIColor colorWithRed: 255/255.0f green: 217/255.0f blue: 1/255.0f alpha: 1] CGColor]];
    
    black = [CAGradientLayer layer];
    black.colors = @[(id)[[UIColor blackColor] CGColor], (id)[[UIColor blackColor] CGColor]];

    blue = [CAGradientLayer layer];
//    blue.colors = @[(id)[[UIColor blackColor] CGColor], (id)[[UIColor blueColor] CGColor]];
    blue.colors = @[(id)[[UIColor colorWithRed: 30/255.0f green: 142/255.0f blue: 253/255.0f alpha: 1] CGColor],
                    (id)[[UIColor colorWithRed: 18/255.0f green: 87/255.0f blue: 155/255.0f alpha: 1] CGColor]];
    
    brown = [CAGradientLayer layer];
//    brown.colors = @[(id)[[UIColor blackColor] CGColor], (id)[[UIColor brownColor] CGColor]];
    brown.colors = @[(id)[[UIColor colorWithRed: 116/255.0f green: 85/255.0f blue: 54/255.0f alpha: 1] CGColor],
                     (id)[[UIColor colorWithRed: 101/255.0f green: 68/255.0f blue: 34/255.0f alpha: 1] CGColor]];
    
    
    gray = [CAGradientLayer layer];
//    gray.colors = @[(id)[[UIColor blackColor] CGColor], (id)[[UIColor grayColor] CGColor]];
    gray.colors = @[(id)[[UIColor colorWithRed: 117/255.0f green: 117/255.0f blue: 117/255.0f alpha: 1] CGColor],
                    (id)[[UIColor colorWithRed: 102/255.0f green: 102/255.0f blue: 102/255.0f alpha: 1] CGColor]];
    
    
    green = [CAGradientLayer layer];
//    green.colors = @[(id)[[UIColor blackColor] CGColor], (id)[[UIColor greenColor] CGColor], (id)[[UIColor blackColor] CGColor]];
    green.colors = @[(id)[[UIColor colorWithRed: 100/255.0f green: 176/255.0f blue: 78/255.0f alpha:1 ] CGColor],
                     (id)[[UIColor colorWithRed: 85/255.0f green: 168/255.0f blue: 60/255.0f alpha: 1] CGColor]];
    
    
    pink = [CAGradientLayer layer];
//    pink.colors = @[(id)[[UIColor blackColor] CGColor], (id)[[UIColor purpleColor] CGColor]];
    pink.colors = @[(id)[[UIColor colorWithRed: 247/255.0f green: 120/255.0f blue: 160/255.0f alpha: 1] CGColor],
                    (id)[[UIColor colorWithRed: 247/255.0f green: 120/255.0f blue: 160/255.0f alpha: 1] CGColor]];
    
    red = [CAGradientLayer layer];
//    red.colors = @[(id)[[UIColor blackColor] CGColor], (id)[[UIColor redColor] CGColor]];
    red.colors = @[(id)[[UIColor colorWithRed: 215/255.0f green: 49/255.0f blue: 49/255.0f alpha: 1] CGColor],
                   (id)[[UIColor colorWithRed: 205/255.0f green: 2/255.0f blue: 2/255.0f alpha: 1] CGColor]];
    
    white = [CAGradientLayer layer];
    white.colors = @[(id)[[UIColor whiteColor] CGColor],(id)[[UIColor whiteColor] CGColor]];

    colors = [[NSDictionary alloc] initWithObjects: @[blue,     yellow,   green,    orange,    black,    white,      brown, pink, gray, red]
                                           forKeys: @[@"Blue", @"Yellow", @"Green", @"Orange", @"Black", @"White", @"Brown", @"Pink", @"Gray", @"Red"]];
    
    self.colorArrange = @[@"Blue", @"Yellow", @"Green", @"Orange", @"Black", @"White", @"Brown", @"Pink", @"Gray", @"Red"];
    
    // mode:
    // 1 for numbers
    // 2 for colors
    mode = 1;
    
    self.selectClickCounter = 0;
    [self playMP3File: @"hello"];
    
    self.lockView = [[UIView alloc] initWithFrame: [[UIScreen mainScreen] bounds]];
    
    self.isRandom = NO;
    
    self.bumpAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    bumpAnimation.fromValue = [NSValue valueWithCATransform3D:CATransform3DMakeScale(1.0, 1.0, 1.0)];
    bumpAnimation.toValue = [NSValue valueWithCATransform3D:CATransform3DMakeScale(1.2f, 1.2f, 1.2f)];
    bumpAnimation.duration = .3f;
    bumpAnimation.autoreverses = YES;
  }
  return self;
}

- (void) initColors
{
  for (UIButton *button in buttons) {
    for (UIView *subView in [button subviews]) {
      [subView removeFromSuperview];
    }
  }
  
  int a[10], i, nvalues = 10;

  if (self.isRandom) {
     
    // random code
    
    for(i = 0; i < nvalues; i++)
      a[i] = i + 1;
    
    for(i = 0; i < nvalues-1; i++) {
      int c = randrange(nvalues-i);
      int t = a[i]; a[i] = a[i+c]; a[i+c] = t;	/* swap */
    }

  } else {
    
    for(i = 0; i < nvalues; i++){
      
      a[i] = i + 1;
    }
  }
  

//  for (NSString *gradientType in [colors allKeys]) {
  
  for (int i = 0; i < [self.colorArrange count]; i++) {
  
    NSString *gradientType = [self.colorArrange objectAtIndex: i];
    
    UIButton *cButton = (UIButton *)self.buttons[a[i] - 1];
    CAGradientLayer *gradient = [colors objectForKey: gradientType];
    
    UIImageView *strokeImageView;
    
    
    [UIView transitionWithView: cButton
                      duration: 1.0
                       options: UIViewAnimationOptionTransitionFlipFromLeft
                    animations: nil
                    completion: NULL];
    
    if ([gradientType isEqualToString: @"White"]) {
      if ((a[i] - 1) < 9) {
        
        strokeImageView = [[UIImageView alloc] initWithImage: [UIImage imageNamed: @"Dots-105x91-black"]];
      } else {
        
        strokeImageView = [[UIImageView alloc] initWithImage: [UIImage imageNamed: @"Dots-213x91-black"]];
      }
    } else {
      if ((a[i] - 1) < 9) {
        
        strokeImageView = [[UIImageView alloc] initWithImage: [UIImage imageNamed: @"Dots-105x91-white"]];
      } else {
        
        strokeImageView = [[UIImageView alloc] initWithImage: [UIImage imageNamed: @"Dots-213x91-white"]];
      }
    }
    
    [cButton addSubview: strokeImageView];
    
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

  }
}

- (void)viewDidLoad
{
  [super viewDidLoad];
  // Do any additional setup after loading the view from its nib.
  
//  UISwipeGestureRecognizer *recognizer;
  recognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(selectButtonClicked:)];
  [recognizer setDirection:UISwipeGestureRecognizerDirectionRight];
  [[self view] addGestureRecognizer:recognizer];

//  UISwipeGestureRecognizer *recognizer1;
  recognizer1 = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(selectButtonClicked:)];
  [recognizer1 setDirection:UISwipeGestureRecognizerDirectionLeft];
  [[self view] addGestureRecognizer:recognizer1];
  
  
  [self.selectButton setImage: [UIImage imageNamed: [NSString stringWithFormat: @"game-%d", self.mode]]
                     forState: UIControlStateNormal];

  
  [self initColors];
}

- (IBAction) buttonClicked:(id)sender
{
 
  [self lockUI];;
  int64_t delayInSeconds = DEFAULT_UILOCKTIME;
  dispatch_time_t updateTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
  dispatch_after(updateTime, dispatch_get_main_queue(), ^(void){
    
    [self releaseUILock];
  });

  
  AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
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
  switch (self.mode) {
    case 1:
      [self.selectButton setImage: [UIImage imageNamed: @"game-2"] forState: UIControlStateNormal];
      self.mode = 2;
      
      notaButton.hidden = YES;
//        randomButton.hidden = YES;
      
      break;
      
    case 2:
      [self.selectButton setImage: [UIImage imageNamed: @"game-1"] forState: UIControlStateNormal];
      self.mode = 1;

      notaButton.hidden = NO;
//        randomButton.hidden = NO;
      break;
      
    default:
      break;
  }
  
  self.isRandom = NO;
  
  [UIView transitionWithView: self.view
                    duration: 1.0
                     options: ([sender direction] != UISwipeGestureRecognizerDirectionLeft ? UIViewAnimationOptionTransitionFlipFromLeft : UIViewAnimationOptionTransitionFlipFromRight)
                  animations: ^(void) { [self playMP3File: [NSString stringWithFormat: @"%d-voice", self.mode]]; [self initColors]; }
                  completion: nil];  
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

- (void) lockUI
{
  [self.view addSubview: lockView];
  
  [self.view removeGestureRecognizer: recognizer];
  [self.view removeGestureRecognizer: recognizer1];  
}

- (void) releaseUILock
{
  [self.lockView removeFromSuperview];
  [[self view] addGestureRecognizer:recognizer];
  [[self view] addGestureRecognizer:recognizer1];
}

- (IBAction) notaButtonClicked:(id)sender
{
  [self playMP3File: @"numbers-song"];
  [self lockUI];
  int64_t delayInSeconds = 10.0f;
  dispatch_time_t updateTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
  dispatch_after(updateTime, dispatch_get_main_queue(), ^(void){
    
    [self releaseUILock];
  });
  

  
  dispatch_time_t updateTimeA;
  
  updateTimeA = dispatch_time(DISPATCH_TIME_NOW, 0.0f * NSEC_PER_SEC);
  dispatch_after(updateTimeA, dispatch_get_main_queue(), ^(void){
    
    [[[self getButtonByNumber: 1] layer] addAnimation: self.bumpAnimation forKey: @"scaling"];
    NSLog(@"delay: %d", 1);
  });


  updateTimeA = dispatch_time(DISPATCH_TIME_NOW, 1 * NSEC_PER_SEC);
  dispatch_after(updateTimeA, dispatch_get_main_queue(), ^(void){
    
    [[[self getButtonByNumber: 2] layer] addAnimation: self.bumpAnimation forKey: @"scaling"];
    NSLog(@"delay: %d", 2);
  });

  updateTimeA = dispatch_time(DISPATCH_TIME_NOW, 1.5f * NSEC_PER_SEC);
  dispatch_after(updateTimeA, dispatch_get_main_queue(), ^(void){
    
    [[[self getButtonByNumber: 3] layer] addAnimation: self.bumpAnimation forKey: @"scaling"];
    NSLog(@"delay: %d", 3);
  });

  updateTimeA = dispatch_time(DISPATCH_TIME_NOW, 2.8f * NSEC_PER_SEC);
  dispatch_after(updateTimeA, dispatch_get_main_queue(), ^(void){
    
    [[[self getButtonByNumber: 4] layer] addAnimation: self.bumpAnimation forKey: @"scaling"];
    NSLog(@"delay: %d", 4);
  });

  updateTimeA = dispatch_time(DISPATCH_TIME_NOW, 3.5f * NSEC_PER_SEC);
  dispatch_after(updateTimeA, dispatch_get_main_queue(), ^(void){
    
    [[[self getButtonByNumber: 5] layer] addAnimation: self.bumpAnimation forKey: @"scaling"];
    NSLog(@"delay: %d", 5);
  });

  updateTimeA = dispatch_time(DISPATCH_TIME_NOW, 4.2f * NSEC_PER_SEC);
  dispatch_after(updateTimeA, dispatch_get_main_queue(), ^(void){
    
    [[[self getButtonByNumber: 6] layer] addAnimation: self.bumpAnimation forKey: @"scaling"];
    NSLog(@"delay: %d", 6);
  });

  updateTimeA = dispatch_time(DISPATCH_TIME_NOW, 5 * NSEC_PER_SEC);
  dispatch_after(updateTimeA, dispatch_get_main_queue(), ^(void){
    
    [[[self getButtonByNumber: 7] layer] addAnimation: self.bumpAnimation forKey: @"scaling"];
    NSLog(@"delay: %d", 7);
  });

  updateTimeA = dispatch_time(DISPATCH_TIME_NOW, 6 * NSEC_PER_SEC);
  dispatch_after(updateTimeA, dispatch_get_main_queue(), ^(void){
    
    [[[self getButtonByNumber: 8] layer] addAnimation: self.bumpAnimation forKey: @"scaling"];
    NSLog(@"delay: %d", 8);
  });

  updateTimeA = dispatch_time(DISPATCH_TIME_NOW, 7 * NSEC_PER_SEC);
  dispatch_after(updateTimeA, dispatch_get_main_queue(), ^(void){
    
    [[[self getButtonByNumber: 9] layer] addAnimation: self.bumpAnimation forKey: @"scaling"];
    NSLog(@"delay: %d", 9);
  });

  updateTimeA = dispatch_time(DISPATCH_TIME_NOW, 8 * NSEC_PER_SEC);
  dispatch_after(updateTimeA, dispatch_get_main_queue(), ^(void){
    
    [[[self getButtonByNumber: 10] layer] addAnimation: self.bumpAnimation forKey: @"scaling"];
    NSLog(@"delay: %d", 10);
  });

}

- (IBAction) randomButtonClicked:(id)sender
{
  self.isRandom = self.isRandom ? NO : YES;
  [self initColors];
}

- (UIButton *) getButtonByNumber:(int)number
{
  for (UIButton *button in buttons) {
    
    if (button.tag == number) {
    
      return button;
    }
  }
                   
  NSLog(@"Not found button number: %d", number);
  return NO;
}

- (void)didReceiveMemoryWarning
{
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

@end
