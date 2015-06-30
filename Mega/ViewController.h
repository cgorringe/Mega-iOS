//
//  ViewController.h
//  Mega App
//
//  Created by Carl Gorringe on 4/7/12.
//  Copyright (c) 2012 Carl Gorringe. All rights reserved.
//
//  This work is licensed under the the terms of the GNU General Public License version 3 (GPLv3)
//  http://www.gnu.org/licenses/gpl-3.0.html
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController {
  NSTimer *timer;
  float firstX, firstY;  // used in pan gesture
}


// ball views
@property (nonatomic, strong) IBOutletCollection(UIView) NSArray *ballViews;
@property (nonatomic, weak)   IBOutlet UIView *megaView;

// ball labels
@property (nonatomic, strong) IBOutletCollection(UILabel) NSArray *ballLabels;
@property (nonatomic, weak)   IBOutlet UILabel *megaLabel;

// methods
- (IBAction)tapToRandomize:(id)sender;
- (void)randomizeBallLabels;
- (void)randomizeBallPositions;

// gesture methods
- (IBAction)handlePanGesture:(UIPanGestureRecognizer *)sender;


@end
