/*
 * Author: Andreas Linde <mail@andreaslinde.de>
 *
 * Copyright (c) 2012-2013 HockeyApp, Bit Stadium GmbH.
 * All rights reserved.
 *
 * Permission is hereby granted, free of charge, to any person
 * obtaining a copy of this software and associated documentation
 * files (the "Software"), to deal in the Software without
 * restriction, including without limitation the rights to use,
 * copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the
 * Software is furnished to do so, subject to the following
 * conditions:
 *
 * The above copyright notice and this permission notice shall be
 * included in all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
 * EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
 * OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
 * NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
 * HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
 * WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
 * FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
 * OTHER DEALINGS IN THE SOFTWARE.
 */

#import "BITDemoViewController.h"
#import "BITSettingsViewController.h"
#import "HockeySDK.h"
#import "BITAuthenticator_Private.h"

@interface BITDemoViewController ()

@end

@implementation BITDemoViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  
  self.navigationItem.leftBarButtonItem =  [[[UIBarButtonItem alloc] initWithTitle:@"Settings"
                                                                             style:UIBarButtonItemStyleBordered
                                                                            target:self
                                                                            action:@selector(showSettings)] autorelease];

  self.title = NSLocalizedString(@"App", @"");
}

- (void)showSettings {
  BITSettingsViewController *hockeySettingsViewController = [[[BITSettingsViewController alloc] init] autorelease];
  UINavigationController *navController = [[[UINavigationController alloc] initWithRootViewController:hockeySettingsViewController] autorelease];
  navController.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
  [self presentViewController:navController animated:YES completion:nil];
}

- (IBAction)openUpdateView {
  [[BITHockeyManager sharedHockeyManager].updateManager showUpdateView];
}

- (IBAction)openFeedbackView {
  [[BITHockeyManager sharedHockeyManager].feedbackManager showFeedbackListView];
}

- (IBAction)openShareActivity {
  Class activityViewControllerClass = NSClassFromString(@"UIActivityViewController");
  // Framework not available, older iOS
  if (activityViewControllerClass) {

    BITFeedbackActivity *feedbackActivity = [[BITFeedbackActivity alloc] init];
  
    __block UIActivityViewController *activityViewController = [[UIActivityViewController alloc] initWithActivityItems:@[@"Share this text"]
                                                                                               applicationActivities:@[feedbackActivity]];
    activityViewController.excludedActivityTypes = @[UIActivityTypeAssignToContact];
  
    [self presentViewController:activityViewController animated:YES completion:^{
      activityViewController.excludedActivityTypes = nil;
      activityViewController = nil;
    }];
  }
}


- (IBAction) triggerCrash {
	/* Trigger a crash */
	CFRelease(NULL);
}


- (IBAction) triggerExceptionCrash {
	/* Trigger a crash */
  NSArray *array = [NSArray array];
  [array objectAtIndex:23];
}

- (IBAction)authenticateInstallation:(UIButton *)sender {
  BITAuthenticator *authenticator =   [BITHockeyManager sharedHockeyManager].authenticator;
  sender.enabled = NO;
  [authenticator authenticateWithCompletion:^(NSString *authenticationToken, NSError *error) {
    NSLog(@"Token: %@", authenticationToken);
    NSLog(@"Error: %@", error);
    sender.enabled = YES;
  }];
}

- (IBAction)validateInstallation:(UIButton*)sender {
  BITAuthenticator *authenticator =   [BITHockeyManager sharedHockeyManager].authenticator;
  
  sender.enabled = NO;
  [authenticator validateInstallationWithCompletion:^(BOOL validated, NSError *error) {
    NSLog(@"Validated: %d", validated);
    NSLog(@"Error: %@", error);
    sender.enabled = YES;
  }];
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation {
  if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
    return YES;
  }else {
    return toInterfaceOrientation != UIInterfaceOrientationPortraitUpsideDown;
  }
}


@end
