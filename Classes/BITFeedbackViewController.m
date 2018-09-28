//
//  BITFeedbackViewController.m
//  HockeySDK-iOSDemo
//
//  Created by Andreas Linde on 20.10.13.
//
//

#import "BITFeedbackViewController.h"

#import "HockeySDK.h"
#import "HockeySDKPrivate.h"


@interface BITFeedbackViewController ()

@end


@implementation BITFeedbackViewController

- (id)initWithStyle:(UITableViewStyle)style {
  self = [super initWithStyle:style];
  if (self) {
    // Custom initialization
  }
  return self;
}


#pragma mark - Private

- (void)openShareActivity {
  BITFeedbackActivity *feedbackActivity = [[BITFeedbackActivity alloc] init];
  feedbackActivity.customActivityTitle = @"Feedback";
  
  __block UIActivityViewController *activityViewController = [[UIActivityViewController alloc] initWithActivityItems:@[@"Share this text"]
                                                                                               applicationActivities:@[feedbackActivity]];
  activityViewController.excludedActivityTypes = @[UIActivityTypeAssignToContact];
  
  if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
    activityViewController.popoverPresentationController.sourceView = self.view;
  }
  
  [self presentViewController:activityViewController animated:YES completion:^{
    activityViewController.excludedActivityTypes = nil;
    activityViewController = nil;
  }];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(__unused UITableView *)tableView {
  return 4;
}

- (NSInteger)tableView:(__unused UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  if (section == 0) {
    return 4;
  } else if (section == 1) {
    return 4;
  }
  
  return 1;
}

- (NSString *)tableView:(__unused UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
  if (section == 0) {
    return NSLocalizedString(@"View Controllers", @"");
  } else if (section == 1) {
      return NSLocalizedString(@"Observation", @"");
  } else {
    return NSLocalizedString(@"Alerts", @"");
  }
  return nil;
}

- (NSString *)tableView:(__unused UITableView *)tableView titleForFooterInSection:(NSInteger)section {
  if (section == 0 || section == 3) {
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
      cell.textLabel.text = NSLocalizedString(@"Modal presentation", @"");
    } else if (indexPath.row == 1) {
      cell.textLabel.text = NSLocalizedString(@"Compose feedback", @"");
    } else if (indexPath.row == 2) {
      cell.textLabel.text = NSLocalizedString(@"Compose with screenshot", @"");
    } else {
      cell.textLabel.text = NSLocalizedString(@"Compose with data", @"");
    }
  } else if (indexPath.section == 1) {
    if (indexPath.row == 0) {
      cell.textLabel.text = NSLocalizedString(@"None", @"");
    } else if (indexPath.row == 1) {
      cell.textLabel.text = NSLocalizedString(@"ModeOnScreenshot", @"");
    } else if (indexPath.row == 2) {
      cell.textLabel.text = NSLocalizedString(@"ModeThreeFingerTap", @"");
    } else {
      cell.textLabel.text = NSLocalizedString(@"ModeAll", @"");
    }
  } else if (indexPath.section == 2) {
    cell.textLabel.text = NSLocalizedString(@"Activity/Share", @"");
  } else {
    cell.textLabel.text = NSLocalizedString(@"New feedback available", @"");
  }
  return cell;
}


#pragma mark - Table view delegate
 
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  [tableView deselectRowAtIndexPath:indexPath animated:YES];
  
  if (indexPath.section == 0) {
    if (indexPath.row == 0) {
      [[BITHockeyManager sharedHockeyManager].feedbackManager showFeedbackListView];
    } else if (indexPath.row == 1) {
      [[BITHockeyManager sharedHockeyManager].feedbackManager showFeedbackComposeView];
    } else if (indexPath.row == 2) {
      [[BITHockeyManager sharedHockeyManager].feedbackManager showFeedbackComposeViewWithGeneratedScreenshot];
    } else {
      NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
      NSString *settingsDir = [(NSString *)[paths objectAtIndex:0] stringByAppendingPathComponent:BITHOCKEY_IDENTIFIER];
      
      NSData *binaryData = [NSData dataWithContentsOfFile:[settingsDir stringByAppendingPathComponent:@"BITFeedbackManager.plist"]];
      // Only do this if we have binary data. Use one of the other API first, then do this.
      if(binaryData) {
        [[BITHockeyManager sharedHockeyManager].feedbackManager showFeedbackComposeViewWithPreparedItems:@[binaryData]];
      }
    }
  } else if (indexPath.section == 1) {
    if (indexPath.row == 0) {
      [[BITHockeyManager sharedHockeyManager].feedbackManager setFeedbackObservationMode:BITFeedbackObservationNone];
    } else if (indexPath.row == 1) {
      [[BITHockeyManager sharedHockeyManager].feedbackManager setFeedbackObservationMode:BITFeedbackObservationModeOnScreenshot];
    } else if (indexPath.row == 2) {
      [[BITHockeyManager sharedHockeyManager].feedbackManager setFeedbackObservationMode:BITFeedbackObservationModeThreeFingerTap];
    } else {
      [[BITHockeyManager sharedHockeyManager].feedbackManager setFeedbackObservationMode:BITFeedbackObservationModeAll];
    }
  } else if (indexPath.section == 2) {
    [self openShareActivity];
  } else {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:BITHockeyLocalizedString(@"HockeyFeedbackNewMessageTitle")
                                                                             message:BITHockeyLocalizedString(@"HockeyFeedbackNewMessageText")
                                                                      preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *ignoreAction = [UIAlertAction actionWithTitle:BITHockeyLocalizedString(@"HockeyFeedbackIgnore")
                                                           style:UIAlertActionStyleCancel
                                                         handler:^(UIAlertAction __unused *action) {}];
    [alertController addAction:ignoreAction];
    UIAlertAction *showAction = [UIAlertAction actionWithTitle:BITHockeyLocalizedString(@"HockeyFeedbackShow")
                                                         style:UIAlertActionStyleDefault
                                                       handler:^(UIAlertAction __unused *action) {}];
    [alertController addAction:showAction];
    
    [self presentViewController:alertController animated:YES completion:nil];
  }
}


@end
