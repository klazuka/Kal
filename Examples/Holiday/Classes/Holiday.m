/* 
 * Copyright (c) 2009 Keith Lazuka
 * License: http://www.opensource.org/licenses/mit-license.html
 */

#import "Holiday.h"

@implementation Holiday

@synthesize date, name, country;

+ (Holiday*)holidayNamed:(NSString *)aName country:(NSString *)aCountry date:(NSDate *)aDate;
{
  return [[[Holiday alloc] initWithName:aName country:aCountry date:aDate] autorelease];
}

- (id)initWithName:(NSString *)aName country:(NSString *)aCountry date:(NSDate *)aDate
{
  if ((self = [super init])) {
    name = [aName copy];
    country = [aCountry copy];
    date = [aDate retain];
  }
  return self;
}

- (NSComparisonResult)compare:(Holiday *)otherHoliday
{
  NSComparisonResult comparison = [self.date compare:otherHoliday.date];
  if (comparison == NSOrderedSame)
    return [self.name compare:otherHoliday.name];
  else
    return comparison;
}

- (void)dealloc
{
  [date release];
  [name release];
  [country release];
  [super dealloc];
}

@end
