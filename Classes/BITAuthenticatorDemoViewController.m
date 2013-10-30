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


- (void)viewDidLoad {
  [super viewDidLoad];
 
  self.restrictAppUsageSwitch = [[UISwitch alloc] initWithFrame:CGRectZero];
  [self.restrictAppUsageSwitch setOn:YES animated:NO];
}


#pragma mark - Private

- (void)authenticateAnonymous {
  BITAuthenticator *authenticator = BITHockeyManager.sharedHockeyManager.authenticator;
  [authenticator cleanupInternalStorage];
  authenticator.identificationType = BITAuthenticatorIdentificationTypeAnonymous;
  authenticator.restrictApplicationUsage = self.restrictAppUsageSwitch.isOn;
  [authenticator authenticateInstallation];
}

- (void)authenticateDevice {
  BITAuthenticator *authenticator = BITHockeyManager.sharedHockeyManager.authenticator;
  [authenticator cleanupInternalStorage];
  authenticator.identificationType = BITAuthenticatorIdentificationTypeDevice;
  authenticator.restrictApplicationUsage = self.restrictAppUsageSwitch.isOn;
  [authenticator authenticateInstallation];
}

- (void)authenticateEmail {
  BITAuthenticator *authenticator = BITHockeyManager.sharedHockeyManager.authenticator;
  [authenticator cleanupInternalStorage];
  authenticator.identificationType = BITAuthenticatorIdentificationTypeHockeyAppEmail;
  authenticator.restrictApplicationUsage = self.restrictAppUsageSwitch.isOn;
  [authenticator authenticateInstallation];
}

- (void)authenticateAccount {
  BITAuthenticator *authenticator = BITHockeyManager.sharedHockeyManager.authenticator;
  [authenticator cleanupInternalStorage];
  authenticator.identificationType = BITAuthenticatorIdentificationTypeHockeyAppUser;
  authenticator.restrictApplicationUsage = self.restrictAppUsageSwitch.isOn;
  [authenticator authenticateInstallation];
}

- (void)authenticateWebAuth {
  BITAuthenticator *authenticator = BITHockeyManager.sharedHockeyManager.authenticator;
  [authenticator cleanupInternalStorage];
  authenticator.identificationType = BITAuthenticatorIdentificationTypeWebAuth;
  authenticator.restrictApplicationUsage = NO;
  [authenticator identifyWithCompletion:nil];
}

#pragma mark -
- (void)authenticateInstallation {
  BITAuthenticator *authenticator =   [BITHockeyManager sharedHockeyManager].authenticator;
//  sender.enabled = NO;
  [authenticator identifyWithCompletion:^(BOOL identified, NSError *error) {
    NSLog(@"Identified: %d", identified);
    NSLog(@"Error: %@", error);
//    sender.enabled = YES;
  }];
}

- (void)validateInstallation {
  BITAuthenticator *authenticator =   [BITHockeyManager sharedHockeyManager].authenticator;
  
//  sender.enabled = NO;
  [authenticator validateWithCompletion:^(BOOL validated, NSError *error) {
    NSLog(@"Validated: %d", validated);
    NSLog(@"Error: %@", error);
//    sender.enabled = YES;
  }];
}

- (void)resetAuthenticator {
  BITAuthenticator *authenticator =   [BITHockeyManager sharedHockeyManager].authenticator;
  [authenticator cleanupInternalStorage];
}



- (void)askForIdentification {
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
  [alertView show];
}


- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
  switch((AuthenticatorDemoAlertViewTag)alertView.tag) {
    case AuthenticatorDemoAlertViewTagAsking:
      [self askingAlertView:alertView clickedButtonAtIndex:buttonIndex];
      break;
    case AuthenticatorDemoAlertViewTagMessages:
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

- (void)checkAndBlock {
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
- (void)handleAlerts:(NSInteger)index {
  UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil
                                                      message:[self authenticatorAlertMessages][index]
                                                     delegate:self
                                            cancelButtonTitle:@"OK"
                                            otherButtonTitles:nil];
  alertView.tag = AuthenticatorDemoAlertViewTagMessages;
  [alertView show];
}

- (NSArray *) authenticatorAlertMessages {
  static NSArray *messages = nil;
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    messages = @[ BITHockeyLocalizedString(@"HockeyAuthenticationViewControllerNetworkError"),
                  BITHockeyLocalizedString(@"HockeyAuthenticationFailedAuthenticate"),
                  BITHockeyLocalizedString(@"HockeyAuthenticationNotMember"),
                  BITHockeyLocalizedString(@"HockeyAuthenticationContactDeveloper"),
                  BITHockeyLocalizedString(@"HockeyAuthenticationWrongEmailPassword"),
                 ];
  });
  
  return messages;
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  if (section == 0) {
    return 6;
  } else if (section == 1) {
    return 5;
  } else if (section == 2) {
    return 3;
  } else {
    return 2;
  }
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
  if (section == 0) {
    return NSLocalizedString(@"Authenticate", @"");
  } else if (section == 1) {
    return NSLocalizedString(@"Alerts", @"");
  } else if (section == 2) {
    return NSLocalizedString(@"Tests", @"");
  } else {
    return NSLocalizedString(@"Internal Tests", @"");
  }
  return nil;
}

- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section {
  if (section == 0 || section == 1) {
    return NSLocalizedString(@"Presented UI relevant for localization", @"");
  }
  
  return nil;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  static NSString *CellIdentifier = @"Cell";
  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
  if (cell == nil) {
    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
  }
  
  // Configure the cell...
  if (indexPath.section == 0) {
    if (indexPath.row == 0) {
      cell.textLabel.text = NSLocalizedString(@"Anonymous", @"");
    } else if (indexPath.row == 1) {
      cell.textLabel.text = NSLocalizedString(@"Device", @"");
    } else if (indexPath.row == 2) {
      cell.textLabel.text = NSLocalizedString(@"Email", @"");
    } else if (indexPath.row == 3) {
      cell.textLabel.text = NSLocalizedString(@"Account", @"");
    } else if (indexPath.row == 4) {
      cell.textLabel.text = NSLocalizedString(@"WebAuth", @"");
    } else {
      cell.textLabel.text = NSLocalizedString(@"Restrict application usage", @"");
      cell.accessoryView = self.restrictAppUsageSwitch;
    }
  } else if (indexPath.section == 1) {
    if (indexPath.row == 0) {
      cell.textLabel.text = NSLocalizedString(@"Network Error", @"");
    } else if (indexPath.row == 1) {
      cell.textLabel.text = NSLocalizedString(@"Failed Authenticate", @"");
    } else if (indexPath.row == 2) {
      cell.textLabel.text = NSLocalizedString(@"Not Member", @"");
    } else if (indexPath.row == 3) {
      cell.textLabel.text = NSLocalizedString(@"Contact Developer", @"");
    } else {
      cell.textLabel.text = NSLocalizedString(@"Wrong Email/Password", @"");
    }
  } else if (indexPath.section == 2) {
    if (indexPath.row == 0) {
      cell.textLabel.text = NSLocalizedString(@"Identify", @"");
    } else if (indexPath.row == 1) {
      cell.textLabel.text = NSLocalizedString(@"Validate", @"");
    } else {
      cell.textLabel.text = NSLocalizedString(@"Reset", @"");
    }
  } else {
    if (indexPath.row == 0) {
      cell.textLabel.text = NSLocalizedString(@"Ask for ident", @"");
    } else {
      cell.textLabel.text = NSLocalizedString(@"Validate and potentially block", @"");
    }
  }
  
  return cell;
}


#pragma mark - Table view delegate

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  if (indexPath.section == 0 && indexPath.row == 5) {
    return nil;
  }
  
  return indexPath;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  [tableView deselectRowAtIndexPath:indexPath animated:YES];
  
  if (indexPath.section == 0) {
    if (indexPath.row == 0) {
      [self authenticateAnonymous];
    } else if (indexPath.row == 1) {
      [self authenticateDevice];
    } else if (indexPath.row == 2) {
      [self authenticateEmail];
    } else if (indexPath.row == 3) {
      [self authenticateAccount];
    } else if (indexPath.row == 4) {
      [self authenticateWebAuth];
    }
  } else if (indexPath.section == 1) {
    [self handleAlerts:indexPath.row];
  } else if (indexPath.section == 2) {
    if (indexPath.row == 0) {
      [self authenticateInstallation];
    } else if (indexPath.row == 1) {
      [self validateInstallation];
    } else {
      [self resetAuthenticator];
    }
  } else {
    if (indexPath.row == 0) {
      [self askForIdentification];
    } else {
      [self checkAndBlock];
    }
  }
}

@end
