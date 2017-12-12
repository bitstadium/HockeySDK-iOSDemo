/*
 * Author: Andreas Linde <mail@andreaslinde.de>
 *
 * Copyright (c) 2012-2014 HockeyApp, Bit Stadium GmbH.
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

#import "BITAuthenticatorDemoViewController.h"
#import "BITBetaUpdatesViewController.h"
#import "BITStoreUpdatesViewController.h"
#import "BITFeedbackViewController.h"
#import "BITCrashReportsViewController.h"


@interface BITDemoViewController ()<UIAlertViewDelegate>

@end


@implementation BITDemoViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  
  self.navigationItem.leftBarButtonItem =  [[UIBarButtonItem alloc] initWithTitle:@"Settings"
                                                                             style:UIBarButtonItemStylePlain
                                                                            target:self
                                                                            action:@selector(showSettings)];

  self.title = NSLocalizedString(@"App", @"");
}

- (void)showSettings {
  BITSettingsViewController *hockeySettingsViewController = [[BITSettingsViewController alloc] init];
  UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:hockeySettingsViewController];
  navController.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
  [self presentViewController:navController animated:YES completion:nil];
}


#pragma mark - view controller

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
  return UIInterfaceOrientationMaskAllButUpsideDown;
}

- (BOOL) shouldAutorotate {
  return YES;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(__unused UITableView *)tableView {
  // Return the number of sections.
  return 1;
}


- (NSInteger)tableView:(__unused UITableView *)tableView numberOfRowsInSection:(__unused NSInteger)section {
  // Return the number of rows in the section.
  return 6;
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  
  static NSString *CellIdentifier = @"Cell";
  
  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
  if (cell == nil) {
    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
  }
  
  // Configure the cell...
  switch (indexPath.row) {
    case 0: {
      cell.textLabel.text = NSLocalizedString(@"Authorize", @"");
      break;
    }
      
    case 1: {
      cell.textLabel.text = NSLocalizedString(@"Beta Updates", @"");
      break;
    }
      
    case 2: {
      cell.textLabel.text = NSLocalizedString(@"Store Updates", @"");
      break;
    }
      
    case 3: {
      cell.textLabel.text = NSLocalizedString(@"Feedback", @"");
      break;
    }
      
    case 4: {
      cell.textLabel.text = NSLocalizedString(@"Crash Reports", @"");
      break;
    }
      
    case 5: {
      cell.textLabel.text = NSLocalizedString(@"Track Event", @"");
      break;
    }
      
    default:
      break;
  }
  
  cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
  
  return cell;
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  [tableView deselectRowAtIndexPath:indexPath animated:YES];
  
  switch (indexPath.row) {
    case 0: {
      BITAuthenticatorDemoViewController *vc = [[BITAuthenticatorDemoViewController alloc] initWithNibName:nil bundle:nil];
      [self.navigationController pushViewController:vc animated:YES];
      break;
    }
      
    case 1: {
      BITBetaUpdatesViewController *vc = [[BITBetaUpdatesViewController alloc] initWithNibName:nil bundle:nil];
      [self.navigationController pushViewController:vc animated:YES];
      break;
    }
    
    case 2: {
      BITStoreUpdatesViewController *vc = [[BITStoreUpdatesViewController alloc] initWithNibName:nil bundle:nil];
      [self.navigationController pushViewController:vc animated:YES];
      break;
    }
      
    case 3: {
      BITFeedbackViewController *vc = [[BITFeedbackViewController alloc] initWithNibName:nil bundle:nil];
      [self.navigationController pushViewController:vc animated:YES];
      break;
    }

    case 4: {
      BITCrashReportsViewController *vc = [[BITCrashReportsViewController alloc] initWithNibName:nil bundle:nil];
      [self.navigationController pushViewController:vc animated:YES];
      break;
    }
      
    case 5: {
      BITMetricsManager *metricsManager = [BITHockeyManager sharedHockeyManager].metricsManager;
      [metricsManager trackEventWithName:@"TEST"];
      break;
    }
      
    default:
      break;
  }
}


@end
