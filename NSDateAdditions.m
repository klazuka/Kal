/* 
 * Copyright (c) 2009 Keith Lazuka
 * License: http://www.opensource.org/licenses/mit-license.html
 */

#import "NSDateAdditions.h"

@implementation NSDate (KalAdditions)

+ (NSDate *)cc_today { return [NSDate date]; }

+ (NSDate *)cc_dateForDay:(NSUInteger)day month:(NSUInteger)month year:(NSUInteger)year
{
  NSDateComponents *c = [[[NSDateComponents alloc] init] autorelease];
  c.day = day;
  c.month = month;
  c.year = year;
  return [[NSCalendar currentCalendar] dateFromComponents:c];
}

- (BOOL)cc_isToday
{
  // Performance optimization because [NSCalendar componentsFromDate:] is expensive.
  // (I verified this with Shark)
  if (ABS([self timeIntervalSinceDate:[NSDate date]]) > 86400)
    return NO;
  
  NSDateComponents *c1 = [self cc_componentsForMonthDayAndYear];
  NSDateComponents *c2 = [[NSDate cc_today] cc_componentsForMonthDayAndYear];
  return c1.day == c2.day && c1.month == c2.month && c1.year == c2.year && c1.era == c2.era;
}

- (NSDate *)cc_dateByMovingToFirstDayOfTheMonth
{
  NSDate *d = nil;
  BOOL ok = [[NSCalendar currentCalendar] rangeOfUnit:NSMonthCalendarUnit startDate:&d interval:NULL forDate:self];
  NSAssert1(ok, @"Failed to calculate the first day the month based on %@", self);
  return d;
}

- (NSDate *)cc_dateByMovingToFirstDayOfThePreviousMonth
{
  NSDateComponents *c = [[[NSDateComponents alloc] init] autorelease];
  c.month = -1;
  return [[[NSCalendar currentCalendar] dateByAddingComponents:c toDate:self options:0] cc_dateByMovingToFirstDayOfTheMonth];  
}

- (NSDate *)cc_dateByMovingToFirstDayOfTheFollowingMonth
{
  NSDateComponents *c = [[[NSDateComponents alloc] init] autorelease];
  c.month = 1;
  return [[[NSCalendar currentCalendar] dateByAddingComponents:c toDate:self options:0] cc_dateByMovingToFirstDayOfTheMonth];
}

- (NSDateComponents *)cc_componentsForMonthDayAndYear
{
  return [[NSCalendar currentCalendar] components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit fromDate:self];
}

- (NSUInteger)cc_day
{
  return (NSUInteger)[[[NSCalendar currentCalendar] components:NSDayCalendarUnit fromDate:self] day];
}

- (NSUInteger)cc_weekday
{
  return [[NSCalendar currentCalendar] ordinalityOfUnit:NSDayCalendarUnit inUnit:NSWeekCalendarUnit forDate:self];
}

- (NSUInteger)cc_numberOfDaysInMonth
{
  return [[NSCalendar currentCalendar] rangeOfUnit:NSDayCalendarUnit inUnit:NSMonthCalendarUnit forDate:self].length;
}

@end