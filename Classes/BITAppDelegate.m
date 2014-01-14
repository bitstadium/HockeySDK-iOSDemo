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

#import "BITAppDelegate.h"
#import "BITDemoViewController.h"
#import "HockeySDK.h"


@interface BITAppDelegate () <BITHockeyManagerDelegate> {}

@end


@implementation BITAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
#if 1 //live
  [[BITHockeyManager sharedHockeyManager] configureWithIdentifier:@"fd51a3647d651add2171dd59d3b6e5ec"
                                                         delegate:self];
  [BITHockeyManager sharedHockeyManager].authenticator.authenticationSecret = @"cdfc46d2c9e8a2f64890a6bb1337eef0";
#else //warmup
  [[BITHockeyManager sharedHockeyManager] configureWithIdentifier:@"ca2aba1482cb9458a67b917930b202c8"
                                                         delegate:self];
  [BITHockeyManager sharedHockeyManager].authenticator.authenticationSecret = @"585935112885d912e95762fc27339a2c";
#endif
  [BITHockeyManager sharedHockeyManager].authenticator.identificationType = BITAuthenticatorIdentificationTypeDevice;
  [BITHockeyManager sharedHockeyManager].authenticator.restrictApplicationUsage = NO;
  
  // optionally enable logging to get more information about states.
  [BITHockeyManager sharedHockeyManager].debugLogEnabled = YES;

  [[BITHockeyManager sharedHockeyManager] startManager];

  [self.window makeKeyAndVisible];

  if ([self didCrashInLastSessionOnStartup]) {
    [self waitingUI];
  } else {
    [self setupApplication];
  }

  return YES;
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
  return [[BITHockeyManager sharedHockeyManager].authenticator handleOpenURL:url
                                                           sourceApplication:sourceApplication
                                                                  annotation:annotation];
}

- (void)waitingUI {
  // show intermediate UI
  [self.demoViewController.view addSubview:self.demoViewController.waitingView];
  [self.demoViewController.waitingView setHidden:NO];
  [self.demoViewController.navigationItem.leftBarButtonItem setEnabled:NO];
}

- (void)setupApplication {
  // setup your app specific code
  [self.demoViewController.waitingView setHidden:YES];
  [self.demoViewController.waitingView removeFromSuperview];
  [self.demoViewController.navigationItem.leftBarButtonItem setEnabled:YES];
  [self.window makeKeyAndVisible];
  [[BITHockeyManager sharedHockeyManager].authenticator authenticateInstallation];
}

- (BOOL)didCrashInLastSessionOnStartup {
  return ([[BITHockeyManager sharedHockeyManager].crashManager didCrashInLastSession] &&
          [[BITHockeyManager sharedHockeyManager].crashManager timeintervalCrashInLastSessionOccured] < 5);
}


#pragma mark - BITHockeyManagerDelegate

//- (NSString *)userIDForHockeyManager:(BITHockeyManager *)hockeyManager componentManager:(BITHockeyBaseManager *)componentManager {
//  return @"userID";
//}

//- (NSString *)userNameForHockeyManager:(BITHockeyManager *)hockeyManager componentManager:(BITHockeyBaseManager *)componentManager {
//  return @"userName";
//}
//
//- (NSString *)userEmailForHockeyManager:(BITHockeyManager *)hockeyManager componentManager:(BITHockeyBaseManager *)componentManager {
//  return @"userEmail";
//}

- (NSString *)applicationLogForHockeyManager:(BITHockeyManager *)hockeyManager componentManager:(BITHockeyBaseManager *)componentManager {
  return @"applicationLog";
}

#pragma mark - BITCrashManagerDelegate

- (void)crashManagerWillCancelSendingCrashReport:(BITCrashManager *)crashManager {
  if ([self didCrashInLastSessionOnStartup]) {
    [self setupApplication];
  }
}

- (void)crashManager:(BITCrashManager *)crashManager didFailWithError:(NSError *)error {
  if ([self didCrashInLastSessionOnStartup]) {
    [self setupApplication];
  }
}
       
- (void)crashManagerDidFinishSendingCrashReport:(BITCrashManager *)crashManager {
  if ([self didCrashInLastSessionOnStartup]) {
    [self setupApplication];
  }
}

@end
