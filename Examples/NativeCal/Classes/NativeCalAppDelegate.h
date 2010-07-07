/* 
 * Copyright (c) 2010 Keith Lazuka
 * License: http://www.opensource.org/licenses/mit-license.html
 */

#import <UIKit/UIKit.h>

/*
 *    NativeCalAppDelegate
 *    --------------------
 *
 *  This demo app shows how to use Kal to display events
 *  from EventKit (Apple's native calendar database).
 *
 */

@class KalViewController;

@interface NativeCalAppDelegate : NSObject <UIApplicationDelegate, UITableViewDelegate>
{
  UIWindow *window;
  UINavigationController *navController;
  KalViewController *kal;
  id dataSource;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;

@end
