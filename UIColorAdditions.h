//
//  UIColorAdditions.h
//  Kal
//
//  Created by Keith Lazuka on 12/18/09.
//  Copyright 2009 The Polypeptides. All rights reserved.
//

#import <Foundation/Foundation.h>

#define RGBCOLOR(r,g,b) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1]

@interface UIColor (KalAdditions)

+ (UIColor *)calendarTextColor;
+ (UIColor *)calendarTextLightColor;

@end
