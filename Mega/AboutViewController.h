//
//  AboutViewController.h
//  Mega App
//
//  Created by Carl Gorringe on 4/10/12.
//  Copyright (c) 2012 Carl Gorringe. All rights reserved.
//
//  This work is licensed under the the terms of the GNU General Public License version 3 (GPLv3)
//  http://www.gnu.org/licenses/gpl-3.0.html
//

#import <UIKit/UIKit.h>

@interface AboutViewController : UIViewController <UIAlertViewDelegate>

- (IBAction)goBack:(id)sender;
- (IBAction)emailMe:(id)sender;
- (IBAction)openSafari:(id)sender;

@end
