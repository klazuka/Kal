#import "Holiday.h"


@implementation Holiday

@synthesize date, name;

+ (Holiday*)holidayNamed:(NSString *)aName onDate:(NSDate *)aDate
{
  return [[[Holiday alloc] initWithName:aName onDate:aDate] autorelease];
}

- (id)initWithName:(NSString *)aName onDate:(NSDate *)aDate
{
  if ((self = [super init])) {
    name = [aName copy];
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
  [super dealloc];
}


@end
