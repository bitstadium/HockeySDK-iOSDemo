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
  
  [self presentViewController:activityViewController animated:YES completion:^{
    activityViewController.excludedActivityTypes = nil;
    activityViewController = nil;
  }];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  if (section == 0) {
    return 4;
  }
  
  return 1;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
  if (section == 0) {
    return NSLocalizedString(@"View Controllers", @"");
  } else {
    return NSLocalizedString(@"Alerts", @"");
  }
  return nil;
}

- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section {
  if (section == 0 || section == 2) {
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
      NSString *settingsDir = [[paths objectAtIndex:0] stringByAppendingPathComponent:BITHOCKEY_IDENTIFIER];
      
      NSData *binaryData = [NSData dataWithContentsOfFile:[settingsDir stringByAppendingPathComponent:@"BITFeedbackManager.plist"]];
      [[BITHockeyManager sharedHockeyManager].feedbackManager showFeedbackComposeViewWithPreparedItems:@[binaryData]];
    }
  } else if (indexPath.section == 1) {
    [self openShareActivity];
  } else {
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:BITHockeyLocalizedString(@"HockeyFeedbackNewMessageTitle")
                                                        message:BITHockeyLocalizedString(@"HockeyFeedbackNewMessageText")
                                                       delegate:self
                                              cancelButtonTitle:BITHockeyLocalizedString(@"HockeyFeedbackIgnore")
                                              otherButtonTitles:BITHockeyLocalizedString(@"HockeyFeedbackShow"), nil
                              ];
    [alertView show];
  }
}


@end
