#import "TodayViewController.h"
#import <NotificationCenter/NotificationCenter.h>
#import "HockeySDK.h"

@interface TodayViewController () <NCWidgetProviding>

@property (nonatomic, assign) BOOL didSetupHockeySDK;

@end

@implementation TodayViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  if (!self.didSetupHockeySDK) {
    [[BITHockeyManager sharedHockeyManager] configureWithIdentifier:@"fd51a3647d651add2171dd59d3b6e5ec"];
    
    // optionally enable logging to get more information about states.
    [BITHockeyManager sharedHockeyManager].debugLogEnabled = YES;
    [BITHockeyManager sharedHockeyManager].crashManager.crashManagerStatus = BITCrashManagerStatusAutoSend;
    
    
    [[BITHockeyManager sharedHockeyManager] startManager];
    self.didSetupHockeySDK = YES;
  }
  self.preferredContentSize = CGSizeMake(self.view.frame.size.width, 40.0f);
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

- (void)widgetPerformUpdateWithCompletionHandler:(void (^)(NCUpdateResult))completionHandler {
  // Perform any setup necessary in order to update the view.
  
  // If an error is encountered, use NCUpdateResultFailed
  // If there's no update required, use NCUpdateResultNoData
  // If there's an update, use NCUpdateResultNewData
  
  completionHandler(NCUpdateResultNewData);
}

- (IBAction)testCrashTapped:(id)sender {
  /* Trigger a crash */
  NSArray *array = [NSArray array];
  [array objectAtIndex:23];
}

@end
