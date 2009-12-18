//
//  KalAppDelegate.h
//  Kal
//
//  Created by Keith Lazuka on 12/17/09.
//  Copyright The Polypeptides 2009. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface KalAppDelegate : NSObject <UIApplicationDelegate>
{
  UIWindow *window;
  UINavigationController *navController;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;

@end

