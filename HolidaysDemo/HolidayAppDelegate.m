/* 
 * Copyright (c) 2009 Keith Lazuka
 * License: http://www.opensource.org/licenses/mit-license.html
 */

#import "HolidayAppDelegate.h"
#import "HolidayJSONDataSource.h"
#import "HolidaySqliteDataSource.h"
#import "HolidaysDetailViewController.h"
#import "Kal.h"

@implementation HolidayAppDelegate

@synthesize window;

- (void)applicationDidFinishLaunching:(UIApplication *)application
{
  // I provide several different dataSource examples. Pick one by commenting out the others.
  dataSource = [[HolidayJSONDataSource alloc] init];
//  dataSource = [[HolidaySqliteDataSource alloc] init];
  KalViewController *kal = [[KalViewController alloc] init];
  kal.delegate = self;
  kal.dataSource = dataSource;
  kal.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithTitle:@"Today" style:UIBarButtonItemStyleBordered target:kal action:@selector(showAndSelectToday)] autorelease];
  navController = [[UINavigationController alloc] initWithRootViewController:kal];
  [kal release];

  [window addSubview:navController.view];
  [window makeKeyAndVisible];
}

#pragma mark UITableViewDelegate protocol conformance

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
  Holiday *holiday = [dataSource holidayAtIndexPath:indexPath];
  HolidaysDetailViewController *vc = [[HolidaysDetailViewController alloc] initWithHoliday:holiday];
  [navController pushViewController:vc animated:YES];
  [vc release];
}

#pragma mark -

- (void)dealloc
{
  [dataSource release];
  [window release];
  [navController release];
  [super dealloc];
}

@end
