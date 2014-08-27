/* 
 * Copyright (c) 2009 Keith Lazuka
 * License: http://www.opensource.org/licenses/mit-license.html
 */

#import <Foundation/Foundation.h>

@interface KalDate : NSObject
{
  struct {
    NSUInteger month : 4;
    NSUInteger day : 5;
    NSUInteger year : 15;
  } a;
}

+ (KalDate *)dateForDay:(NSUInteger)day month:(NSUInteger)month year:(NSUInteger)year;
+ (KalDate *)dateFromNSDate:(NSDate *)date;

- (id)initForDay:(NSUInteger)day month:(NSUInteger)month year:(NSUInteger)year;
- (NSUInteger)day;
- (NSUInteger)month;
- (NSUInteger)year;
- (NSDate *)NSDate;
- (NSComparisonResult)compare:(KalDate *)otherDate;
- (BOOL)isToday;

@end
