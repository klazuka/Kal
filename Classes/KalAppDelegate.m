//
//  KalAppDelegate.m
//  Kal
//
//  Created by Keith Lazuka on 12/17/09.
//  Copyright __MyCompanyName__ 2009. All rights reserved.
//

#import "KalAppDelegate.h"

@implementation KalAppDelegate

@synthesize window;


- (void)applicationDidFinishLaunching:(UIApplication *)application {    

    // Override point for customization after application launch
    [window makeKeyAndVisible];
}


- (void)dealloc {
    [window release];
    [super dealloc];
}


@end
