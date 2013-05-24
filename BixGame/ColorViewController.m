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
#define MODE_NUMBERS 1 
#define MODE_COLORS 2 
#define MODE_MORENUMBERS 3 
#define MODE_SHAPES 4

@interface ColorViewController ()

@end

@implementation ColorViewController

@synthesize buttons, selectButton, colors, numbers, mode, selectClickCounter;
@synthesize lockView;
@synthesize randomButton, notaButton;
@synthesize recognizer, recognizer1;
@synthesize bumpAnimation;
@synthesize buyButton;
@synthesize colorArrange, colorImages;

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
    
    
    self.shapes = @[@"ellipse", @"circle", @"square", @"halfcircle", @"rectangle", @"rhombus", @"heart", @"star", @"triangle"];
    
    
    mode = MODE_NUMBERS;
    
    self.selectClickCounter = 0;
    [self playMP3File: @"hello"];
    
    self.lockView = [[UIView alloc] initWithFrame: [[UIScreen mainScreen] bounds]];
    
    self.isRandom = NO;
    
    self.bumpAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    bumpAnimation.fromValue = [NSValue valueWithCATransform3D:CATransform3DMakeScale(1.0, 1.0, 1.0)];
    bumpAnimation.toValue = [NSValue valueWithCATransform3D:CATransform3DMakeScale(1.2f, 1.2f, 1.2f)];
    bumpAnimation.duration = .3f;
    bumpAnimation.autoreverses = YES;
    
    NSMutableArray *images = [[NSMutableArray alloc] initWithCapacity: [self.colorArrange count]];
    for (NSString *colorName in self.colorArrange) {
      
      [images addObject: [UIImage imageNamed: colorName]];
    }

    
    self.colorImages = [[NSDictionary alloc] initWithObjects: images
                                                     forKeys: self.colorArrange];
    
    self.network = [Network sharedInstance];

  }
  return self;
}

- (void) initButtons
{
  for (UIButton *button in buttons) {
    for (UIView *subView in [button subviews]) {
      if ([subView isKindOfClass: [UILabel class]]) {
        [subView removeFromSuperview];
      }
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

  // remove gradients from previous cycle
  
//  for (UIButton *cButton in buttons) {
//    
//    for (int cLayer = 0; cLayer < [[[cButton layer] sublayers] count]; cLayer++) {
//      if ([[[[cButton layer] sublayers] objectAtIndex: cLayer] isKindOfClass: [CAGradientLayer class]]) {
//        
//        [[[[cButton layer] sublayers] objectAtIndex: cLayer] removeFromSuperlayer];
//      }
//    }
//  }

  int maxButtons;
  
  if (self.mode == MODE_SHAPES) {
    
    maxButtons = [self.shapes count];
  } else {
    
    maxButtons = [self.colorArrange count];
  }
  
  for (int i = 0; i < maxButtons; i++) {
  
    NSString *gradientType = [self.colorArrange objectAtIndex: i];
    
    UIButton *cButton = (UIButton *)self.buttons[a[i] - 1];
//    CAGradientLayer *gradient = [colors objectForKey: gradientType];
    
    [UIView transitionWithView: cButton
                      duration: 1.0
                       options: UIViewAnimationOptionTransitionFlipFromLeft
                    animations: nil
                    completion: NULL];
    
    [cButton setImage: [self.colorImages objectForKey: gradientType] forState: UIControlStateNormal];
    
    // no dots
    
    /*
     
    UIImageView *strokeImageView;

    if ([gradientType isEqualToString: @"White"] && self.mode != MODE_SHAPES) {
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
    
    if (self.mode != MODE_SHAPES) {
    
      [cButton addSubview: strokeImageView];
    }
    */
    
    UILabel *buttonLabel;
    UIImageView *shapeImageView;
    UIImage *shapeImage;
    
    switch (self.mode) {
      case MODE_COLORS:
        
        // empty cells
        break;
        
      case MODE_NUMBERS:
        
        buttonLabel = [[UILabel alloc] initWithFrame: cButton.bounds];
        buttonLabel.textAlignment = UITextAlignmentCenter;
        buttonLabel.font = [UIFont boldSystemFontOfSize: 48];
        buttonLabel.text = [NSString stringWithFormat: @"%d", i + 1];
        if ([gradientType isEqualToString: @"White"]) {
          buttonLabel.textColor = [UIColor blackColor];
        } else {
          buttonLabel.textColor = [UIColor whiteColor];
        }
        buttonLabel.backgroundColor = [UIColor clearColor];
        [cButton addSubview: buttonLabel];
        
        cButton.tag = i + 1;
                
        break;
        
      case MODE_MORENUMBERS:

        buttonLabel = [[UILabel alloc] initWithFrame: cButton.bounds];
        buttonLabel.textAlignment = UITextAlignmentCenter;
        buttonLabel.font = [UIFont boldSystemFontOfSize: 48];
        buttonLabel.text = [NSString stringWithFormat: @"%d", i + 1 + 10];
        if ([gradientType isEqualToString: @"White"]) {
          buttonLabel.textColor = [UIColor blackColor];
        } else {
          buttonLabel.textColor = [UIColor whiteColor];
        }
        buttonLabel.backgroundColor = [UIColor clearColor];
        [cButton addSubview: buttonLabel];

        cButton.tag = i + 1 + 10;
        
        break;
        
      case MODE_SHAPES:
        
        shapeImage = [UIImage imageNamed: [self.shapes objectAtIndex: i]];
                
        shapeImageView = [[UIImageView alloc] initWithImage: [shapeImage scaleImage: CGSizeMake(85.0f, 75.f)]];
        
        CGFloat x,y;
        x = (cButton.frame.size.width - [shapeImageView image].size.width);
        y = (cButton.frame.size.height - [shapeImageView image].size.height);
        
        shapeImageView.frame = CGRectMake(x, y, [shapeImageView image].size.width - x, [shapeImageView image].size.height - y);
        
        [cButton addSubview: shapeImageView];
        
        cButton.tag = i + 1;
        
        break;
        
      default:
        break;
    }

    // no gradiens at all :(
    // no gradient on shapes

//    if (self.mode != MODE_SHAPES) {
//
//      gradient.frame = cButton.bounds;
//      [[cButton layer] insertSublayer: gradient atIndex:0];
//    }
    
//    [[cButton layer] setCornerRadius: 8.0f];
//    [[cButton layer] setMasksToBounds: YES];

    cButton.cColor = gradientType;
  }
}

- (void)viewDidLoad
{
  [super viewDidLoad];
  // Do any additional setup after loading the view from its nib.
  
  [self.buyButton setImage: [UIImage imageNamed: @"Buy-button"] forState: UIControlStateNormal];

  
//  UISwipeGestureRecognizer *recognizer;
  recognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeDetect:)];
  [recognizer setDirection:UISwipeGestureRecognizerDirectionRight];
  [[self view] addGestureRecognizer:recognizer];

//  UISwipeGestureRecognizer *recognizer1;
  recognizer1 = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeDetect:)];
  [recognizer1 setDirection:UISwipeGestureRecognizerDirectionLeft];
  [[self view] addGestureRecognizer:recognizer1];
  
  
  [self.selectButton setImage: [UIImage imageNamed: [NSString stringWithFormat: @"game-%d", self.mode]]
                     forState: UIControlStateNormal];

  [self initButtons];
  
  if (! [[NSUserDefaults standardUserDefaults] boolForKey: @"splashShowed"]){
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle: @"Здрасти"
                                                    message: @"С играта 'Числа и цветове' ученето е лесно и забавно. Детето ви неусетно ще научи числата и цветовете. При натискане  на съответния бутон детето вижда и чува цифрата или цвета. Играта е подходяща за деца от 2 до 5 години."
                                                   delegate: self
                                          cancelButtonTitle: @"Играй!"
                                          otherButtonTitles: nil];
    [alert show];
    
    
    [[NSUserDefaults standardUserDefaults] setBool: YES forKey: @"splashShowed"];
  }
}

- (IBAction) buttonClicked:(id)sender
{
  if (self.mode == MODE_MORENUMBERS) {
    if (! [self isPaid]) {
      return;
    }
  }
  
  [self lockUI];
  int64_t delayInSeconds = DEFAULT_UILOCKTIME;
  dispatch_time_t updateTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
  dispatch_after(updateTime, dispatch_get_main_queue(), ^(void){
    
    [self releaseUILock];
  });

  AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
  if (self.mode == MODE_NUMBERS || self.mode == MODE_MORENUMBERS) {
    
  
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

- (void) selectMode: (int) newMode
{
  switch (newMode) {
    case MODE_NUMBERS:
      [self.selectButton setImage: [UIImage imageNamed: @"game-1"] forState: UIControlStateNormal];
      self.mode = newMode;
      
      notaButton.hidden = NO;
      //        randomButton.hidden = YES;
      
      [self.buyButton setImage: [UIImage imageNamed: @"Buy-button"] forState: UIControlStateNormal];
      
      SEND_EVENT_NUMBERS
      
      break;
      
    case MODE_COLORS:
      [self.selectButton setImage: [UIImage imageNamed: @"game-2"] forState: UIControlStateNormal];
      self.mode = newMode;
      
      notaButton.hidden = YES;
      //        randomButton.hidden = NO;
      
//      [self.buyButton setImage: [UIImage imageNamed: @"Buy-Shapes"] forState: UIControlStateNormal];
      [self.buyButton setImage: [UIImage imageNamed: @""] forState: UIControlStateNormal];
      
      SEND_EVENT_COLORS
      
      break;
      
    case MODE_MORENUMBERS:

      [self.selectButton setImage: [UIImage imageNamed: @"game-1"] forState: UIControlStateNormal];
      self.mode = newMode;
      
      notaButton.hidden = NO;
      //        randomButton.hidden = NO;
      
      [self.buyButton setImage: [UIImage imageNamed: @""] forState: UIControlStateNormal];
      
      SEND_EVENT_MORE_NUMBERS

      break;
      
    case MODE_SHAPES:

      [self.selectButton setImage: [UIImage imageNamed: @"game-2"] forState: UIControlStateNormal];
      self.mode = newMode;
      
      notaButton.hidden = YES;
      //        randomButton.hidden = NO;
      
      [self.buyButton setImage: [UIImage imageNamed: @""] forState: UIControlStateNormal];

      break;
      
    default:
      break;
  }
  
  self.isRandom = NO;

}

- (void) swipeDetect: (id) sender
{

  NSLog(@"%d", self.mode);
  
  switch (self.mode) {
    case MODE_NUMBERS:
      
      [self selectMode: MODE_MORENUMBERS];
      
      break;
      
    case MODE_MORENUMBERS:
      
      [self selectMode: MODE_NUMBERS];
      
      break;
      
    case MODE_COLORS:
      
//      [self selectMode: MODE_SHAPES];
      
      return;
      
      break;
      
    case MODE_SHAPES:
      
//      [self selectMode: MODE_COLORS];
      
      return;
      
    default:
      break;
  }

  UIViewAnimationOptions animationDirection;
  
  NSLog(@"Direction: %d %d %d", [sender direction],UISwipeGestureRecognizerDirectionLeft, UISwipeGestureRecognizerDirectionRight );

  animationDirection = ([sender direction] != UISwipeGestureRecognizerDirectionLeft ? UIViewAnimationOptionTransitionFlipFromLeft : UIViewAnimationOptionTransitionFlipFromRight);
  [self showTransition: animationDirection];
}

- (void) showTransition: (UIViewAnimationOptions) direction
{
//  if ([sender respondsToSelector: @selector(direction)]) {
//    
//    direction = ([sender direction] != UISwipeGestureRecognizerDirectionLeft ? UIViewAnimationOptionTransitionFlipFromLeft : UIViewAnimationOptionTransitionFlipFromRight);
//  } else {
//    
//    direction = UIViewAnimationOptionTransitionFlipFromLeft;
//  }
  
  [UIView transitionWithView: self.view
                    duration: 1.0
                     options: direction
                  animations: ^(void) { [self playMP3File: [NSString stringWithFormat: @"%d-voice", self.mode]]; [self initButtons]; }
                  completion: nil];
  
}

- (IBAction) selectButtonClicked:(id)sender
{
  switch (self.mode) {
    case MODE_NUMBERS:
    case MODE_MORENUMBERS:
      
      [self selectMode: MODE_COLORS];
      
      break;
      
    case MODE_COLORS:
    case MODE_SHAPES:
      
      [self selectMode: MODE_NUMBERS];
      
    default:
      break;
  }
  
  self.isRandom = NO;
  
  UIViewAnimationOptions direction;
  direction = UIViewAnimationOptionTransitionFlipFromLeft;
  
  [self showTransition: direction];
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
  if (self.mode == MODE_MORENUMBERS) {
    if (! [self isPaid]) {
      return;
    }
  }
  
  if (self.mode == MODE_NUMBERS) {
    
    [self playMP3File: @"numbers-song"];
    
    SEND_EVENT_SONG1
  } else {
    
    [self playMP3File: @"math-song"];
    
    SEND_EVENT_SONG2
  }
  
  [self lockUI];
  int64_t delayInSeconds = 10.0f;
  dispatch_time_t updateTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
  dispatch_after(updateTime, dispatch_get_main_queue(), ^(void){
    
    [self releaseUILock];
  });
  
  dispatch_time_t updateTimeA;
  
  switch (self.mode) {
    case MODE_NUMBERS:
    {
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
    break;
      
      
    case MODE_MORENUMBERS:
    {
//      updateTimeA = dispatch_time(DISPATCH_TIME_NOW, 0.0f * NSEC_PER_SEC);
//      dispatch_after(updateTimeA, dispatch_get_main_queue(), ^(void){
//        
//        [[[self getButtonByNumber: 11] layer] addAnimation: self.bumpAnimation forKey: @"scaling"];
//        NSLog(@"delay: %d", 11);
//      });
//      
//      
//      updateTimeA = dispatch_time(DISPATCH_TIME_NOW, 1 * NSEC_PER_SEC);
//      dispatch_after(updateTimeA, dispatch_get_main_queue(), ^(void){
//        
//        [[[self getButtonByNumber: 12] layer] addAnimation: self.bumpAnimation forKey: @"scaling"];
//        NSLog(@"delay: %d", 12);
//      });
//      
//      updateTimeA = dispatch_time(DISPATCH_TIME_NOW, 1.5f * NSEC_PER_SEC);
//      dispatch_after(updateTimeA, dispatch_get_main_queue(), ^(void){
//        
//        [[[self getButtonByNumber: 13] layer] addAnimation: self.bumpAnimation forKey: @"scaling"];
//        NSLog(@"delay: %d", 13);
//      });
//      
//      updateTimeA = dispatch_time(DISPATCH_TIME_NOW, 2.8f * NSEC_PER_SEC);
//      dispatch_after(updateTimeA, dispatch_get_main_queue(), ^(void){
//        
//        [[[self getButtonByNumber: 14] layer] addAnimation: self.bumpAnimation forKey: @"scaling"];
//        NSLog(@"delay: %d", 14);
//      });
//      
//      updateTimeA = dispatch_time(DISPATCH_TIME_NOW, 3.5f * NSEC_PER_SEC);
//      dispatch_after(updateTimeA, dispatch_get_main_queue(), ^(void){
//        
//        [[[self getButtonByNumber: 15] layer] addAnimation: self.bumpAnimation forKey: @"scaling"];
//        NSLog(@"delay: %d", 15);
//      });
//      
//      updateTimeA = dispatch_time(DISPATCH_TIME_NOW, 4.2f * NSEC_PER_SEC);
//      dispatch_after(updateTimeA, dispatch_get_main_queue(), ^(void){
//        
//        [[[self getButtonByNumber: 16] layer] addAnimation: self.bumpAnimation forKey: @"scaling"];
//        NSLog(@"delay: %d", 16);
//      });
//      
//      updateTimeA = dispatch_time(DISPATCH_TIME_NOW, 5 * NSEC_PER_SEC);
//      dispatch_after(updateTimeA, dispatch_get_main_queue(), ^(void){
//        
//        [[[self getButtonByNumber: 17] layer] addAnimation: self.bumpAnimation forKey: @"scaling"];
//        NSLog(@"delay: %d", 17);
//      });
//      
//      updateTimeA = dispatch_time(DISPATCH_TIME_NOW, 6 * NSEC_PER_SEC);
//      dispatch_after(updateTimeA, dispatch_get_main_queue(), ^(void){
//        
//        [[[self getButtonByNumber: 18] layer] addAnimation: self.bumpAnimation forKey: @"scaling"];
//        NSLog(@"delay: %d", 18);
//      });
//      
//      updateTimeA = dispatch_time(DISPATCH_TIME_NOW, 7 * NSEC_PER_SEC);
//      dispatch_after(updateTimeA, dispatch_get_main_queue(), ^(void){
//        
//        [[[self getButtonByNumber: 19] layer] addAnimation: self.bumpAnimation forKey: @"scaling"];
//        NSLog(@"delay: %d", 19);
//      });
//      
//      updateTimeA = dispatch_time(DISPATCH_TIME_NOW, 8 * NSEC_PER_SEC);
//      dispatch_after(updateTimeA, dispatch_get_main_queue(), ^(void){
//        
//        [[[self getButtonByNumber: 20] layer] addAnimation: self.bumpAnimation forKey: @"scaling"];
//        NSLog(@"delay: %d", 20);
//      });
    }
      break;
    
    default:
      break;
  }
  

}

- (IBAction) randomButtonClicked:(id)sender
{
  if (self.mode == MODE_MORENUMBERS) {
    if (! [self isPaid]) {
      return;
    }
  }
  
  self.isRandom = self.isRandom ? NO : YES;
  [self initButtons];
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

- (IBAction) buyButtonClicked:(id)sender
{
  switch (self.mode) {
    case MODE_NUMBERS:
      
      [self selectMode: MODE_MORENUMBERS];
      
      break;
      
    case MODE_COLORS:
      
      [self selectMode: MODE_SHAPES];
      
    default:
      break;
  }
  
  self.isRandom = NO;
  
  UIViewAnimationOptions direction;
  direction = UIViewAnimationOptionTransitionFlipFromLeft;
  
  [self showTransition: direction];
}

- (BOOL) isPaid
{
  if (! [[NSUserDefaults standardUserDefaults] boolForKey: @"moreNumbersPaid"]) {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle: @"Платено!"
                                                    message: @"Тази част е пластена!\nАко искате да чуете и другите глупости,\nси я купете!\nСтрува само 5001,99лв"
                                                   delegate: self
                                          cancelButtonTitle: @"Не сега"
                                          otherButtonTitles: @"Купи", nil];
    alert.tag = 777;
    [alert show];
    return NO;
  } else {
    return YES;
  }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
  if (alertView.tag == 777 && buttonIndex == 1) {
    
    if (! [[NSUserDefaults standardUserDefaults] boolForKey: @"moreNumbersPaid"]) {
      
      [[NSUserDefaults standardUserDefaults] setBool: YES forKey: @"moreNumbersPaid"];
      [[NSUserDefaults standardUserDefaults] synchronize];
      
      UIAlertView *alert = [[UIAlertView alloc] initWithTitle: @"Платено"
                                                      message: @"Благодарим ви че си дадохте парите! Сега ще се напием!"
                                                     delegate: self
                                            cancelButtonTitle: @"Продължи"
                                            otherButtonTitles: nil];
      [alert show];
      
      SEND_EVENT_PAID_OK
    } 
  } else if (alertView.tag == 777 && ! buttonIndex) {
    
    SEND_EVENT_PAID_CANCEL
  }
}

- (void)didReceiveMemoryWarning
{
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

@end
