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

@interface BITDemoViewController ()<UIAlertViewDelegate>

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
  [authenticator identifyWithCompletion:^(BOOL identified, NSError *error) {
    NSLog(@"Identified: %d", identified);
    NSLog(@"Error: %@", error);
    sender.enabled = YES;
  }];
}

- (IBAction)validateInstallation:(UIButton*)sender {
  BITAuthenticator *authenticator =   [BITHockeyManager sharedHockeyManager].authenticator;
  
  sender.enabled = NO;
  [authenticator validateWithCompletion:^(BOOL validated, NSError *error) {
    NSLog(@"Validated: %d", validated);
    NSLog(@"Error: %@", error);
    sender.enabled = YES;
  }];
}

- (IBAction)resetAuthenticator:(id)sender {
  BITAuthenticator *authenticator =   [BITHockeyManager sharedHockeyManager].authenticator;
  [authenticator cleanupInternalStorage];
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation {
  if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
    return YES;
  }else {
    return toInterfaceOrientation != UIInterfaceOrientationPortraitUpsideDown;
  }
}

- (IBAction)askForIdentification:(id)sender {
  BITAuthenticator *authenticator =   [BITHockeyManager sharedHockeyManager].authenticator;
  [authenticator cleanupInternalStorage];
  //this should've been set on initial app launch
  authenticator.identificationType = BITAuthenticatorIdentificationTypeAnonymous;
  
  //present an alertView and kindly ask the user to identify to allow an easier
  //AdHoc handling
  UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil
                                                      message:@"Would you like to help the developers during the Beta by identifying yourself via your device ID?"
                                                     delegate:self
                                            cancelButtonTitle:@"Never"
                                            otherButtonTitles:@"Sure!", nil];
  [alertView show];
}


- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
  if(alertView.cancelButtonIndex == buttonIndex) {
    //user doesn't want to be identified.
    //you could store a flag to user-defaults and never ask him again
    return;
  }
  
  //cool, lets configure the authenticator and let it show the login view
  BITAuthenticator *authenticator =   [BITHockeyManager sharedHockeyManager].authenticator;
  authenticator.identificationType = BITAuthenticatorIdentificationTypeDevice;
  //you could either switch back authenticator to automatic mode on app launch,
  //or do it all for yourself. For now, just to it ourselves
  //authenticator.automaticMode = YES;
  [authenticator identifyWithCompletion:^(BOOL identified, NSError *error) {
    if(identified) {
      [[[UIAlertView alloc] initWithTitle:nil message:@"Thanks" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
    }
  }];
}

- (IBAction)checkAndBlock:(id)sender {
  BITAuthenticator *authenticator =   [BITHockeyManager sharedHockeyManager].authenticator;
  if(!authenticator.isIdentified) {
    [[[UIAlertView alloc] initWithTitle:@"Error"
                                message:@"Make sure to identify the user first"
                               delegate:nil
                      cancelButtonTitle:@"OK"
                      otherButtonTitles:nil] show];
    return;
  }
  UIAlertView *blockingView = [[UIAlertView alloc] initWithTitle:nil
                                                      message:@"Please stand by..."
                                                     delegate:nil
                                            cancelButtonTitle:nil
                                            otherButtonTitles:nil];
  [authenticator validateWithCompletion:^(BOOL validated, NSError *error) {
    if(validated) {
      [blockingView dismissWithClickedButtonIndex:blockingView.cancelButtonIndex animated:YES];
    } else {
      //if he's not allowed to test the app anymore, show another alert,
      //exit the app, etc.
      UIAlertView *errorAlert = [[UIAlertView alloc] initWithTitle:nil
                                                         message:error.localizedDescription
                                                        delegate:nil
                                               cancelButtonTitle:nil
                                               otherButtonTitles:nil];
      [errorAlert show];
    }
  }];
  [blockingView show];
}

@end
