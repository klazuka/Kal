/* 
 * Copyright (c) 2009 Keith Lazuka
 * License: http://www.opensource.org/licenses/mit-license.html
 */

#import "HolidayCalendarDataSource.h"
#import "Holiday.h"

static NSMutableArray *holidays;

NSDate *DateForMonthDayYear(NSUInteger month, NSUInteger day, NSUInteger year)
{
  NSDateComponents *c = [[[NSDateComponents alloc] init] autorelease];
  c.month = month;
  c.day = day;
  c.year = year;
  return [[NSCalendar currentCalendar] dateFromComponents:c];
}

BOOL IsDateBetweenInclusive(NSDate *date, NSDate *begin, NSDate *end)
{
  return [date compare:begin] != NSOrderedAscending && [date compare:end] != NSOrderedDescending;
}

@interface HolidayCalendarDataSource ()
- (NSArray *)holidaysFrom:(NSDate *)fromDate to:(NSDate *)toDate;
@end

@implementation HolidayCalendarDataSource

+ (HolidayCalendarDataSource *)dataSource
{
  return [[[[self class] alloc] init] autorelease];
}

+ (void)initialize
{
  holidays = [[NSMutableArray alloc] init];
  [holidays addObject:[Holiday holidayNamed:@"TODAY!" onDate:[NSDate date]]];
  // 2009 US Holidays
  [holidays addObject:[Holiday holidayNamed:@"New Year's Day" onDate:DateForMonthDayYear(1, 1, 2009)]];
  [holidays addObject:[Holiday holidayNamed:@"Martin Luther King Day" onDate:DateForMonthDayYear(1, 19, 2009)]];
  [holidays addObject:[Holiday holidayNamed:@"Washington's Birthday" onDate:DateForMonthDayYear(2, 16, 2009)]];
  [holidays addObject:[Holiday holidayNamed:@"Memorial Day" onDate:DateForMonthDayYear(5, 25, 2009)]];
  [holidays addObject:[Holiday holidayNamed:@"Independence Day" onDate:DateForMonthDayYear(7, 4, 2009)]];
  [holidays addObject:[Holiday holidayNamed:@"Labor Day" onDate:DateForMonthDayYear(9, 7, 2009)]];
  [holidays addObject:[Holiday holidayNamed:@"Columbus Day" onDate:DateForMonthDayYear(10, 12, 2009)]];
  [holidays addObject:[Holiday holidayNamed:@"Veterans Day" onDate:DateForMonthDayYear(11, 11, 2009)]];
  [holidays addObject:[Holiday holidayNamed:@"Thanksgiving" onDate:DateForMonthDayYear(11, 26, 2009)]];
  [holidays addObject:[Holiday holidayNamed:@"Christmas" onDate:DateForMonthDayYear(12, 25, 2009)]];
  [holidays addObject:[Holiday holidayNamed:@"New Years Eve" onDate:DateForMonthDayYear(12, 31, 2009)]];
  [holidays addObject:[Holiday holidayNamed:@"Last Day of the Decade" onDate:DateForMonthDayYear(12, 31, 2009)]];
  // 2010 US Holidays
  [holidays addObject:[Holiday holidayNamed:@"New Years Day" onDate:DateForMonthDayYear(1, 1, 2010)]];
  [holidays addObject:[Holiday holidayNamed:@"Martin Luther King Day" onDate:DateForMonthDayYear(1, 18, 2010)]];
  [holidays addObject:[Holiday holidayNamed:@"Washington's Birthday" onDate:DateForMonthDayYear(2, 15, 2010)]];
  [holidays addObject:[Holiday holidayNamed:@"Memorial Day" onDate:DateForMonthDayYear(5, 31, 2010)]];
  [holidays addObject:[Holiday holidayNamed:@"Independence Day" onDate:DateForMonthDayYear(7, 4, 2010)]];
  [holidays addObject:[Holiday holidayNamed:@"Labor Day" onDate:DateForMonthDayYear(9, 6, 2010)]];
  [holidays addObject:[Holiday holidayNamed:@"Columbus Day" onDate:DateForMonthDayYear(10, 11, 2010)]];
  [holidays addObject:[Holiday holidayNamed:@"Veterans Day" onDate:DateForMonthDayYear(11, 11, 2010)]];
  [holidays addObject:[Holiday holidayNamed:@"Thanksgiving" onDate:DateForMonthDayYear(11, 25, 2010)]];
  [holidays addObject:[Holiday holidayNamed:@"Christmas" onDate:DateForMonthDayYear(12, 25, 2010)]];
  [holidays addObject:[Holiday holidayNamed:@"New Years Eve" onDate:DateForMonthDayYear(12, 31, 2010)]];
}

- (id)init
{
  if ((self = [super init])) {
    items = [[NSMutableArray alloc] init];
  }
  return self;
}

#pragma mark UITableViewDataSource protocol conformance

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  static NSString *identifier = @"MyCell";
  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
  if (!cell) {
    cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier] autorelease];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
  }
  
  cell.textLabel.text = [items objectAtIndex:indexPath.row];
  return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
  return [items count];
}

#pragma mark KalDataSource protocol conformance

#define FAKE_LOAD_TIME 1.05f

- (void)presentingDatesFrom:(NSDate *)fromDate to:(NSDate *)toDate delegate:(id<KalDataSourceCallbacks>)delegate
{
  // Create a fake asynchronous load (i.e. querying the database in a separate thread)
  dataReady = NO;
  NSMutableArray *dates = [NSMutableArray array];
  for (Holiday *holiday in [self holidaysFrom:fromDate to:toDate])
    [dates addObject:holiday.date];
  
  [self performSelector:@selector(fakeAsyncTaskFinished) withObject:nil afterDelay:FAKE_LOAD_TIME-0.01];
  [(NSObject*)delegate performSelector:@selector(loadedMarkedDates:) withObject:dates afterDelay:FAKE_LOAD_TIME];
}

- (void)loadItemsFromDate:(NSDate *)fromDate toDate:(NSDate *)toDate
{
  if (!dataReady)
    return;
  
  for (Holiday *holiday in [self holidaysFrom:fromDate to:toDate])
    [items addObject:holiday.name];
}

- (void)removeAllItems
{
  [items removeAllObjects];
}

#pragma mark -

- (NSArray *)holidaysFrom:(NSDate *)fromDate to:(NSDate *)toDate
{
  NSMutableArray *matches = [NSMutableArray array];
  for (Holiday *holiday in holidays)
    if (IsDateBetweenInclusive(holiday.date, fromDate, toDate))
      [matches addObject:holiday];
  
  return matches;
}

- (void)fakeAsyncTaskFinished
{
  dataReady = YES;
}

- (void)dealloc
{
  [items release];
  [super dealloc];
}


@end
