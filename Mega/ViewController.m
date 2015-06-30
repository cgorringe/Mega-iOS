//
//  ViewController.m
//  Mega App
//
//  Created by Carl Gorringe on 4/7/12.
//  Copyright (c) 2012 Carl Gorringe. All rights reserved.
//
//  This work is licensed under the the terms of the GNU General Public License version 3 (GPLv3)
//  http://www.gnu.org/licenses/gpl-3.0.html
//

#import "ViewController.h"

@implementation ViewController

@synthesize ballViews, megaView;
@synthesize ballLabels, megaLabel;

// There are 5 white balls with values 1 to WHITE_BALL_MAX
// #define WHITE_BALL_MAX 56   /* pre-Oct, 2013  */
#define WHITE_BALL_MAX 75      /* post-Oct, 2013 */

// One Mega ball with value 1 to MEGA_BALL_MAX
// #define MEGA_BALL_MAX  46   /* pre-Oct, 2013  */
#define MEGA_BALL_MAX  15      /* post-Oct, 2013 */

////////////////////////////////////////////////////////////////////////////////
#pragma mark - View lifecycle

- (void)didReceiveMemoryWarning
{
  [super didReceiveMemoryWarning];
  // Release any cached data, images, etc that aren't in use.
}

- (void)viewDidLoad
{
  [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.

  [self randomizeBallLabels];
}

- (void)viewDidUnload
{
  [super viewDidUnload];
  // Release any retained subviews of the main view.
  // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
  [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
  [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
  // Return YES for supported orientations
  if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
    // iPhone
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
  } else {
    // iPad
    return YES;
  }
}

////////////////////////////////////////////////////////////////////////////////
// new code

// This is called when the user double-taps to move the balls

- (IBAction)tapToRandomize:(id)sender
{
  //NSLog(@"pressRandomizeButton");

  // if not using the timer, just call this once
  //[self randomizeBallLabels];

  // first stop the timer if it's still going
  // ( This is a good piece of code to take note of when dealing with timers.
  //   I've seen code that only does [timer invalidate], and they tend to crash! )
  if (timer) { [timer invalidate]; timer = nil; }

  // start a timer to randomize the ball labels repeatedly every 0.2 seconds
  timer = [NSTimer scheduledTimerWithTimeInterval:0.2 
                                           target:self 
                                         selector:@selector(randomizeBallLabels) 
                                         userInfo:nil 
                                          repeats:YES];
  // animate the balls for 1.0 second
  [UIView animateWithDuration:1.0 
    animations:^{
      [self randomizeBallPositions];
    } 
    completion:^(BOOL finished){
      // stop the random number timer when animation completes
      if (timer) { [timer invalidate]; timer = nil; }
    }
  ];
}


// This will generate random lotto numbers for the ball labels.
// There are 5 white balls and 1 mega ball.

- (void)randomizeBallLabels
{
  int pos, pick, mega;
  int balls[WHITE_BALL_MAX];

  // initialize the array of balls
  for (int i=0; i < WHITE_BALL_MAX; i++) {
    balls[i] = i + 1;
  }

  // choose 5 random balls without picking the same ball twice
  for (int i=0; i < [self.ballLabels count]; i++) {

    // This is an interesting read on the problem of using the rand() function:
    // http://eternallyconfuzzled.com/arts/jsw_art_rand.aspx
    // Another read on what to use:
    // http://nshipster.com/random/

    // select a random position within the array of balls
    pos = i + arc4random_uniform(WHITE_BALL_MAX - i);

    // swap the value in that position with one in the start of the array
    pick = balls[pos];
    balls[pos] = balls[i];
    balls[i] = pick;
    
    // assign ball number to the white ball label
    UILabel *ballLabel = [self.ballLabels objectAtIndex:i];
    ballLabel.text = [NSString stringWithFormat:@"%i", balls[i]];
  }
  // now the 5 random balls are in balls[0] thru balls[4]

  // finally, we set the mega ball
  mega = arc4random_uniform(MEGA_BALL_MAX) + 1;
  self.megaLabel.text  = [NSString stringWithFormat:@"%i", mega];
  
  // refresh the view
  [self.view setNeedsDisplay];
}


// Change the position of the balls
- (void)randomizeBallPositions
{
  int xmin = self.megaView.frame.size.width / 2;
  int ymin = self.megaView.frame.size.height / 2;
  int xmax = self.view.bounds.size.width - self.megaView.frame.size.width;
  int ymax = self.view.bounds.size.height - self.megaView.frame.size.height - 100;

  for (UIView *ballView in self.ballViews) {
    ballView.center = CGPointMake(arc4random_uniform(xmax) + xmin, arc4random_uniform(ymax) + ymin);
  }
  self.megaView.center  = CGPointMake(arc4random_uniform(xmax) + xmin, arc4random_uniform(ymax) + ymin);
}

////////////////////////////////////////////////////////////////////////////////
// Gestures

// In the storyboard, add a Tap Gesture Recognizer, then under "Sent Actions" 
// on the right, point the selector to the view controller and select the
// tapToRandomize method.  Change it's taps attribute to "2" for
// double-tap.  No coding required.

// To add Pan Gestures, add a Pan Gesture Recognizer for every ball's view (6).
// Point every "Sent Actions" selector to this method, which can be named
// anything, doesn't have to be "handlePanGesture", as long as the rest stays 
// the same.

// In order to link a Pan Gesture to a ball's UIView in the Storyboard, go to 
// the list of objects on the left, then drag the "Pan Gesture Recognizer" over 
// to the View that contains the image and label.  This should add an item to
// the gesture's "Referencing Outlet Collections" and to the view's 
// "Outlet Collections".  Repeat this for every pan gesture, one for every
// ball view.

- (IBAction)handlePanGesture:(UIPanGestureRecognizer *)sender
{
  // retrieves the view of the ball that the user is panning
  UIView *thisView = sender.view;

  // the "translation" is the offset or relative or delta position from the point
  // where the user began the panning, to the current position of the user's finger
  CGPoint translate = [sender translationInView:self.view];

  // bring the ball's view in front of all the other balls
  [self.view bringSubviewToFront:thisView];
  
  if (sender.state == UIGestureRecognizerStateBegan) {
    // this runs once, right at the start of the panning gesture
    firstX = thisView.center.x;
    firstY = thisView.center.y;
  }
  else if (sender.state == UIGestureRecognizerStateChanged) {
    // this runs multiple times, during the panning gesture
    thisView.center = CGPointMake(firstX + translate.x, firstY + translate.y);
  }
  else if (sender.state == UIGestureRecognizerStateEnded) {
    // this runs once, at the end when the user lifts their finger
    //NSLog(@"pan gesture: x = %.1f  y = %.1f", translate.x, translate.y);
  }
}


@end
