//
//  AboutViewController.m
//  Mega App
//
//  Created by Carl Gorringe on 4/10/12.
//  Copyright (c) 2012 Carl Gorringe. All rights reserved.
//
//  This work is licensed under the the terms of the GNU General Public License version 3 (GPLv3)
//  http://www.gnu.org/licenses/gpl-3.0.html
//

#import "AboutViewController.h"

@implementation AboutViewController

enum {
  kEmailAlert
};

////////////////////////////////////////////////////////////////////////////////
#pragma mark - View lifecycle

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
  self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
  if (self) {
    // Custom initialization
  }
  return self;
}

- (void)didReceiveMemoryWarning
{
  // Releases the view if it doesn't have a superview.
  [super didReceiveMemoryWarning];
  
  // Release any cached data, images, etc that aren't in use.
}

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView
{
}
*/

/*
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
  [super viewDidLoad];
}
*/

- (void)viewDidUnload
{
  [super viewDidUnload];
  // Release any retained subviews of the main view.
  // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
  // Return YES for supported orientations
  return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

////////////////////////////////////////////////////////////////////////////////
#pragma mark - Actions
// new code

- (IBAction)goBack:(id)sender
{
  // This returns us back to the previous view
  [self dismissViewControllerAnimated:YES completion:nil];
}


// Open a web link in the Safari App
- (IBAction)openSafari:(id)sender
{
  NSURL *url = [NSURL URLWithString:@"http://example.com/"];
  if (![[UIApplication sharedApplication] openURL:url]) {
    NSLog(@"Failed to open %@", [url description]);
  }
}

/*
  Here are some special URLs that will open the App Store App instead
  of Safari when you try to open them.  These also work when clicking on
  these links from a website viewed from the iPhone's browser!

* This will load the app store to list all your apps. ("More Apps" button)
    itms-apps://itunes.com/apps/yourname

* This will load your app, good for a "Rate This App" button:
  (this only works once you know your app's ID number in the app store!)
    itms-apps://itunes.apple.com/us/app/MY_APP/id123456789

* This will open the Mail app:
    mailto://name@example.com
  With included subject:
    mailto://name@example.com?subject=My%20app
  
  Replace any spaces with "%20", as is necessary for any web URL.
 
*/


// Popup an alert asking first before emailing the author.
// ( which is a good idea because otherwise people will accidentally
//   send you blank emails.  This has happened to me! )

- (IBAction)emailMe:(id)sender
{
  UIAlertView *alert = [[UIAlertView alloc] 
                        initWithTitle:@"Email Me!" 
                        message:@"Would you like to email the author?" 
                        delegate:self 
                        cancelButtonTitle:@"No" 
                        otherButtonTitles:@"Yes", nil];
  alert.tag = kEmailAlert;
	[alert show];
}

/////////////////////////////////////////////////////////////////////////////// 
#pragma mark - UIAlertViewDelegate


- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
  // Email Author
  if ((alertView.tag == kEmailAlert) && (buttonIndex == 1)) {
    NSURL *url = [NSURL URLWithString:@"mailto://name@example.com?subject=My%20app"];
    if (![[UIApplication sharedApplication] openURL:url]) {
      NSLog(@"Failed to open %@", [url description]);
    }
  }
}

///////////////////////////////////////////////////////////////////////////////
@end
