#import "KalDataSource.h"


@implementation SimpleKalDataSource

+ (SimpleKalDataSource*)dataSource
{
  return [[[[self class] alloc] init] autorelease];
}

- (void)loadDate:(NSDate *)date
{
}

- (BOOL)hasDetailsForDate:(NSDate *)date
{
  return NO;
}

@end
