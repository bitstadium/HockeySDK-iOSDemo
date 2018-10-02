//
//  BITStoreUpdatesViewController.m
//  HockeySDK-iOSDemo
//
//  Created by Andreas Linde on 20.10.13.
//
//

#import "BITStoreUpdatesViewController.h"

#import "HockeySDK.h"
#import "HockeySDKPrivate.h"


@interface BITStoreUpdatesViewController ()

@end


@implementation BITStoreUpdatesViewController

- (id)initWithStyle:(UITableViewStyle)style {
  self = [super initWithStyle:style];
  if (self) {
    // Custom initialization
  }
  return self;
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(__unused UITableView *)tableView {
  return 1;
}

- (NSInteger)tableView:(__unused UITableView *)tableView numberOfRowsInSection:(__unused NSInteger)section {
  return 1;
}

- (NSString *)tableView:(__unused UITableView *)tableView titleForHeaderInSection:(__unused NSInteger)section {
  return NSLocalizedString(@"Alerts", @"");
}

- (NSString *)tableView:(__unused UITableView *)tableView titleForFooterInSection:(__unused NSInteger)section {
  return NSLocalizedString(@"Presented UI relevant for localization", @"");
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(__unused NSIndexPath *)indexPath {
  static NSString *CellIdentifier = @"Cell";
  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
  if (cell == nil) {
    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
  }
  
  // Configure the cell...
  cell.textLabel.text = NSLocalizedString(@"New Update available", @"");
  
  return cell;
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  [tableView deselectRowAtIndexPath:indexPath animated:YES];
  NSString *versionString = [NSString stringWithFormat:@"%@ %@", BITHockeyLocalizedString(@"UpdateVersion"), @"6.0"];
  UIAlertController *alertController = [UIAlertController alertControllerWithTitle:BITHockeyLocalizedString(@"UpdateAvailable")
                                                                           message:[NSString stringWithFormat:BITHockeyLocalizedString(@"UpdateAlertTextWithAppVersion"), versionString]
                                                                    preferredStyle:UIAlertControllerStyleAlert];
  UIAlertAction *ignoreAction = [UIAlertAction actionWithTitle:BITHockeyLocalizedString(@"UpdateIgnore")
                                                           style:UIAlertActionStyleCancel
                                                         handler:^(UIAlertAction __unused *action) {}];
  [alertController addAction:ignoreAction];
  UIAlertAction *remindAction = [UIAlertAction actionWithTitle:BITHockeyLocalizedString(@"UpdateRemindMe")
                                                       style:UIAlertActionStyleDefault
                                                     handler:^(UIAlertAction __unused *action) {}];
  [alertController addAction:remindAction];
  
  UIAlertAction *showAction = [UIAlertAction actionWithTitle:BITHockeyLocalizedString(@"UpdateShow")
                                                             style:UIAlertActionStyleDefault
                                                           handler:^(UIAlertAction __unused *action) {}];
  [alertController addAction:showAction];
  
  [self presentViewController:alertController animated:YES completion:nil];
}

@end
