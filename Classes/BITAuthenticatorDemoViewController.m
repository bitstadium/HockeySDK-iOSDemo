//
//  BITAuthenticatorDemoViewController.m
//  HockeySDK-iOSDemo
//
//  Created by Stephan Diederich on 14.10.13.
//
//

#import "BITAuthenticatorDemoViewController.h"
#import "HockeySDK.h"
#import "HockeySDKPrivate.h"

typedef NS_ENUM(NSUInteger, AuthenticatorDemoAlertViewTag) {
  AuthenticatorDemoAlertViewTagOther = 0,
  AuthenticatorDemoAlertViewTagAsking,
  AuthenticatorDemoAlertViewTagMessages
};
@interface BITAuthenticatorDemoViewController ()

@end

@implementation BITAuthenticatorDemoViewController

- (void)dealloc {
  [_restrictAppUsageSwitch release];
  [super dealloc];
}

#pragma mark -
- (IBAction)authenticateAnonymous:(UIButton *)sender {
  BITAuthenticator *authenticator = BITHockeyManager.sharedHockeyManager.authenticator;
  [authenticator cleanupInternalStorage];
  authenticator.identificationType = BITAuthenticatorIdentificationTypeAnonymous;
  authenticator.restrictApplicationUsage = self.restrictAppUsageSwitch.isOn;
  [authenticator authenticateInstallation];
}

- (IBAction)authenticateDevice:(UIButton *)sender {
  BITAuthenticator *authenticator = BITHockeyManager.sharedHockeyManager.authenticator;
  [authenticator cleanupInternalStorage];
  authenticator.identificationType = BITAuthenticatorIdentificationTypeDevice;
  authenticator.restrictApplicationUsage = self.restrictAppUsageSwitch.isOn;
  [authenticator authenticateInstallation];
}

- (IBAction)authenticateEmail:(UIButton *)sender {
  BITAuthenticator *authenticator = BITHockeyManager.sharedHockeyManager.authenticator;
  [authenticator cleanupInternalStorage];
  authenticator.identificationType = BITAuthenticatorIdentificationTypeHockeyAppEmail;
  authenticator.restrictApplicationUsage = self.restrictAppUsageSwitch.isOn;
  [authenticator authenticateInstallation];
}

- (IBAction)authenticateAccount:(UIButton *)sender {
  BITAuthenticator *authenticator = BITHockeyManager.sharedHockeyManager.authenticator;
  [authenticator cleanupInternalStorage];
  authenticator.identificationType = BITAuthenticatorIdentificationTypeHockeyAppUser;
  authenticator.restrictApplicationUsage = self.restrictAppUsageSwitch.isOn;
  [authenticator authenticateInstallation];
}

/*
- (IBAction)authenticateWebAuth:(UIButton *)sender {
  BITAuthenticator *authenticator = BITHockeyManager.sharedHockeyManager.authenticator;
  [authenticator cleanupInternalStorage];
  authenticator.identificationType = BITAuthenticatorIdentificationType;
  authenticator.restrictApplicationUsage = NO;
  [authenticator identifyWithCompletion:nil];
}
 */

#pragma mark -
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
  alertView.tag = AuthenticatorDemoAlertViewTagAsking;
  [alertView autorelease];
  [alertView show];
}


- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
  switch((AuthenticatorDemoAlertViewTag)alertView.tag) {
    case AuthenticatorDemoAlertViewTagAsking:
      [self askingAlertView:alertView clickedButtonAtIndex:buttonIndex];
      break;
    case AuthenticatorDemoAlertViewTagMessages:
      [self messagesAlertView:alertView clickedButtonAtIndex:buttonIndex];
      break;
    case AuthenticatorDemoAlertViewTagOther:
      break;
  }
}

- (void) askingAlertView:(UIAlertView*) alertView clickedButtonAtIndex:(NSInteger) buttonIndex {
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

- (void) messagesAlertView:(UIAlertView*) alertView clickedButtonAtIndex:(NSInteger) buttonIndex {
  [self handleAlerts:nil];
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

#pragma mark -
- (IBAction)handleAlerts:(id)sender {
  static NSUInteger currentMessageIndex = 0;
  if(currentMessageIndex >= [self authenticatorAlertMessages].count) {
    currentMessageIndex = 0;
    return;
  }

  UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil
                                                      message:[self authenticatorAlertMessages][currentMessageIndex++]
                                                     delegate:self
                                            cancelButtonTitle:@"OK"
                                            otherButtonTitles:nil];
  alertView.tag = AuthenticatorDemoAlertViewTagMessages;
  [alertView autorelease];
  [alertView show];
}

- (NSArray *) authenticatorAlertMessages {
  static NSArray *messages = nil;
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    messages = [@[ BITHockeyLocalizedString(@"HockeyAuthenticationViewControllerNetworkError"),
                  BITHockeyLocalizedString(@"HockeyAuthenticationFailedAuthenticate"),
                  BITHockeyLocalizedString(@"HockeyAuthenticationNotMember"),
                  BITHockeyLocalizedString(@"HockeyAuthenticationContactDeveloper"),
                  BITHockeyLocalizedString(@"HockeyAuthenticationWrongEmailPassword"),
                 ] retain];
  });
  
  return messages;
}

@end
