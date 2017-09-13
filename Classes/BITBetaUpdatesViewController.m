//
//  BITBetaUpdatesViewController.m
//  HockeySDK-iOSDemo
//
//  Created by Andreas Linde on 20.10.13.
//
//

#import "BITBetaUpdatesViewController.h"

#import "HockeySDK.h"
#import "HockeySDKPrivate.h"


@interface BITBetaUpdatesViewController ()

@end


@implementation BITBetaUpdatesViewController

- (id)initWithStyle:(UITableViewStyle)style {
  self = [super initWithStyle:style];
  if (self) {
    // Custom initialization
  }
  return self;
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(__unused UITableView *)tableView {
  // Return the number of sections.
  return 2;
}

- (NSInteger)tableView:(__unused UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  if (section == 0) {
    return 1;
  } else {
    return 3;
  }
}

- (NSString *)tableView:(__unused UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
  if (section == 0) {
    return NSLocalizedString(@"View Controllers", @"");
  } else {
    return NSLocalizedString(@"Alerts", @"");
  }
  return nil;
}

- (NSString *)tableView:(__unused UITableView *)tableView titleForFooterInSection:(__unused NSInteger)section {
  return NSLocalizedString(@"Presented UI relevant for localization", @"");
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  static NSString *CellIdentifier = @"Cell";
  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
  if (cell == nil) {
    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
  }
  
  // Configure the cell...
  if (indexPath.section == 0) {
    cell.textLabel.text = NSLocalizedString(@"Beta Updates", @"");
  } else {
    if (indexPath.row == 0) {
      cell.textLabel.text = NSLocalizedString(@"Update available", @"");
    } else if (indexPath.row == 1) {
      cell.textLabel.text = NSLocalizedString(@"Update available (3 buttons)", @"");
    } else {
      cell.textLabel.text = NSLocalizedString(@"Mandatory update available", @"");
    }
  }
  return cell;
}


#pragma mark - Table view delegate
 
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  [tableView deselectRowAtIndexPath:indexPath animated:YES];
  
  if (indexPath.section == 0) {
    [[BITHockeyManager sharedHockeyManager].updateManager showUpdateView];
  } else {
    if (indexPath.row == 2) {
      UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:BITHockeyLocalizedString(@"UpdateAvailable")
                                                          message:[NSString stringWithFormat:BITHockeyLocalizedString(@"UpdateAlertMandatoryTextWithAppVersion"), @"DemoApp 5.0 (284)"]
                                                         delegate:self
                                                cancelButtonTitle:BITHockeyLocalizedString(@"UpdateInstall")
                                                otherButtonTitles:nil
                                ];
      [alertView show];
    } else {
      UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:BITHockeyLocalizedString(@"UpdateAvailable")
                                                          message:[NSString stringWithFormat:BITHockeyLocalizedString(@"UpdateAlertTextWithAppVersion"), @"DemoApp 5.0 (284)"]
                                                         delegate:self
                                                cancelButtonTitle:BITHockeyLocalizedString(@"UpdateIgnore")
                                                otherButtonTitles:BITHockeyLocalizedString(@"UpdateShow"), nil
                                ];
      if (indexPath.row == 1) {
        [alertView addButtonWithTitle:BITHockeyLocalizedString(@"UpdateInstall")];
      }
      [alertView show];
    }
  }
}

@end
