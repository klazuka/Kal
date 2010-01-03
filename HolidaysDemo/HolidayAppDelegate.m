/* 
 * Copyright (c) 2009 Keith Lazuka
 * License: http://www.opensource.org/licenses/mit-license.html
 */

#import "HolidayAppDelegate.h"
#import "HolidayJSONDataSource.h"
#import "HolidaySqliteDataSource.h"
#import "Kal.h"

@implementation HolidayAppDelegate

@synthesize window;

- (void)applicationDidFinishLaunching:(UIApplication *)application
{
  // I provide several different dataSource examples. Pick one by commenting out the others.
//  KalViewController *kal = [[KalViewController alloc] initWithDataSource:[HolidayJSONDataSource dataSource]];
  KalViewController *kal = [[KalViewController alloc] initWithDataSource:[HolidaySqliteDataSource dataSource]];
  navController = [[UINavigationController alloc] initWithRootViewController:kal];
  kal.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithTitle:@"Today" style:UIBarButtonItemStyleBordered target:kal action:@selector(showAndSelectToday)] autorelease];
  [kal release];
  [window addSubview:navController.view];
  [window makeKeyAndVisible];
}

- (void)dealloc
{
  [window release];
  [navController release];
  [super dealloc];
}

@end
