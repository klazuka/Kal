/* 
 * Copyright (c) 2009 Keith Lazuka
 * License: http://www.opensource.org/licenses/mit-license.html
 */

#import <UIKit/UIKit.h>

/*
 *    HolidayAppDelegate
 *    ------------------
 *
 *  This demo app shows how to use Kal to display 2009 and 2010
 *  world holidays. I have provided 2 example data sources:
 *
 *    1. HolidayJSONDataSource - fetches JSON data from the internet
 *    2. HolidaySqliteDataSource - queries a local Sqlite database
 *
 *  Both data sources use the same logical data and both present
 *  the data to the user in the same way (via UITableViewCells).
 *  The only difference is in the way that they retrieve the data.
 *
 *  HolidayAppDelegate implements the UITableViewDelegate protocol
 *  so that it can respond to the user tapping the name of a holiday
 *  below the calendar by pushing a details view controller onto
 *  the navigation stack.
 *
 */

@class KalViewController;

@interface HolidayAppDelegate : NSObject <UIApplicationDelegate, UITableViewDelegate>
{
  UIWindow *window;
  UINavigationController *navController;
  KalViewController *kal;
  id dataSource;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;

@end
