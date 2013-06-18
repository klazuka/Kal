/* 
 * Copyright (c) 2009 Keith Lazuka
 * License: http://www.opensource.org/licenses/mit-license.html
 */

#import <Foundation/Foundation.h>

@interface KalDate : NSObject
{
  struct {
    unsigned int month : 4;
    unsigned int day : 5;
    unsigned int year : 15;
  } a;
}

+ (KalDate *)dateForDay:(unsigned int)day month:(unsigned int)month year:(unsigned int)year;
+ (KalDate *)dateFromNSDate:(NSDate *)date;

- (id)initForDay:(unsigned int)day month:(unsigned int)month year:(unsigned int)year;
- (unsigned int)day;
- (unsigned int)month;
- (unsigned int)year;
- (NSDate *)NSDate;
- (NSComparisonResult)compare:(KalDate *)otherDate;
- (BOOL)isToday;

@end
