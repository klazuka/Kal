/* 
 * Copyright (c) 2010 Keith Lazuka
 * License: http://www.opensource.org/licenses/mit-license.html
 */

#import "NativeCalAppDelegate.h"
#import "EventKitDataSource.h"
#import "Kal.h"

#import <EventKit/EventKit.h>
#import <EventKitUI/EventKitUI.h>

@implementation NativeCalAppDelegate

@synthesize window;

- (void)applicationDidFinishLaunching:(UIApplication *)application
{
  /*
   *    Kal Initialization
   *
   * When the calendar is first displayed to the user, Kal will automatically select today's date.
   * If your application requires an arbitrary starting date, use -[KalViewController initWithSelectedDate:]
   * instead of -[KalViewController init].
   */
  kal = [[KalViewController alloc] init];
  kal.title = @"NativeCal";

  /*
   *    Kal Configuration
   *
   */
  kal.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithTitle:@"Today" style:UIBarButtonItemStyleBordered target:self action:@selector(showAndSelectToday)] autorelease];
  kal.delegate = self;
  dataSource = [[EventKitDataSource alloc] init];
  kal.dataSource = dataSource;
  
  // Setup the navigation stack and display it.
  navController = [[UINavigationController alloc] initWithRootViewController:kal];
  [window addSubview:navController.view];
  [window makeKeyAndVisible];
}

// Action handler for the navigation bar's right bar button item.
- (void)showAndSelectToday
{
  [kal showAndSelectDate:[NSDate date]];
}

#pragma mark UITableViewDelegate protocol conformance

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
  // Display a details screen for the selected event/row.
  EKEventViewController *vc = [[[EKEventViewController alloc] init] autorelease];
  vc.event = [dataSource eventAtIndexPath:indexPath];
  vc.allowsEditing = NO;
  [navController pushViewController:vc animated:YES];
}

#pragma mark -

- (void)dealloc
{
  [kal release];
  [dataSource release];
  [window release];
  [navController release];
  [super dealloc];
}

@end
