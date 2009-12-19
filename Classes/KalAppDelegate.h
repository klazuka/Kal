/* 
 * Copyright (c) 2009 Keith Lazuka
 * License: http://www.opensource.org/licenses/mit-license.html
 */

#import <UIKit/UIKit.h>

@interface KalAppDelegate : NSObject <UIApplicationDelegate>
{
  UIWindow *window;
  UINavigationController *navController;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;

@end

