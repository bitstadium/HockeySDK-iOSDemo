//
//  BITCrashReportsViewController.m
//  HockeySDK-iOSDemo
//
//  Created by Andreas Linde on 20.10.13.
//
//

#import "BITCrashReportsViewController.h"

#import "HockeySDK.h"
#import "HockeySDKPrivate.h"


@interface BITCrashReportsViewController ()

@end


@implementation BITCrashReportsViewController

- (id)initWithStyle:(UITableViewStyle)style {
  self = [super initWithStyle:style];
  if (self) {
    // Custom initialization
  }
  return self;
}


#pragma mark - Private

- (void)triggerSignalCrash {
	/* Trigger a crash */
	CFRelease(NULL);
}


- (void)triggerExceptionCrash {
	/* Trigger a crash */
  NSArray *array = [NSArray array];
  [array objectAtIndex:23];
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  if (section == 0) {
    return 2;
  } else {
    return 3;
  }
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
  if (section == 0) {
    return NSLocalizedString(@"Test Crashes", @"");
  } else {
    return NSLocalizedString(@"Alerts", @"");
  }
  return nil;
}

- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section {
  if (section == 1) {
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
      cell.textLabel.text = NSLocalizedString(@"Signal", @"");
    } else {
      cell.textLabel.text = NSLocalizedString(@"Exception", @"");
    }
  } else {
    if (indexPath.row == 0) {
      cell.textLabel.text = NSLocalizedString(@"Anonymous", @"");
    } else if (indexPath.row == 1) {
      cell.textLabel.text = NSLocalizedString(@"Anonymous 3 buttons", @"");
    } else {
      cell.textLabel.text = NSLocalizedString(@"Non-anonymous", @"");
    }
  }
  
  return cell;
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  [tableView deselectRowAtIndexPath:indexPath animated:YES];
  
  if (indexPath.section == 0) {
    if (indexPath.row == 0) {
      [self triggerSignalCrash];
    } else {
      [self triggerExceptionCrash];
    }
  } else {
    NSString *appName = @"DemoApp";
    NSString *alertDescription = [NSString stringWithFormat:BITHockeyLocalizedString(@"CrashDataFoundAnonymousDescription"), appName];
    
    if (indexPath.row == 2) {
      alertDescription = [NSString stringWithFormat:BITHockeyLocalizedString(@"CrashDataFoundDescription"), appName];
    }
    

    
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:[NSString stringWithFormat:BITHockeyLocalizedString(@"CrashDataFoundTitle"), appName]
                                                        message:alertDescription
                                                       delegate:self
                                              cancelButtonTitle:BITHockeyLocalizedString(@"CrashDontSendReport")
                                              otherButtonTitles:BITHockeyLocalizedString(@"CrashSendReport"), nil];
    
    if (indexPath.row == 1) {
      [alertView addButtonWithTitle:BITHockeyLocalizedString(@"CrashSendReportAlways")];
    }
    
    [alertView show];
  }
}

@end
