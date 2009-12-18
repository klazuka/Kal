//
//  KalAppDelegate.m
//  Kal
//
//  Created by Keith Lazuka on 12/17/09.
//  Copyright The Polypeptides 2009. All rights reserved.
//

#import "KalAppDelegate.h"
#import "KalViewController.h"

@implementation KalAppDelegate

@synthesize window;


- (void)applicationDidFinishLaunching:(UIApplication *)application
{    
  navController = [[UINavigationController alloc] initWithRootViewController:[[[KalViewController alloc] init] autorelease]];
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
