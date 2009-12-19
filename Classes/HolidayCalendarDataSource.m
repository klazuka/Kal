//
//  HolidayCalendarDataSource.m
//  TTCalendar
//
//  Created by Keith Lazuka on 7/22/09.
//  Copyright 2009 The Polypeptides. All rights reserved.
//

#import "HolidayCalendarDataSource.h"

static NSMutableDictionary *holidays;

NSDate *DateForDayMonthYear(NSUInteger day, NSUInteger month, NSUInteger year)
{
  NSDateComponents *c = [[[NSDateComponents alloc] init] autorelease];
  c.day = day;
  c.month = month;
  c.year = year;
  return [[NSCalendar currentCalendar] dateFromComponents:c];
}

@implementation HolidayCalendarDataSource

+ (HolidayCalendarDataSource *)dataSource
{
  return [[[[self class] alloc] init] autorelease];
}

+ (void)initialize
{
  holidays = [[NSMutableDictionary alloc] init];
  [holidays setObject:@"New Years Day" forKey:DateForDayMonthYear(1, 1, 2009)];
  [holidays setObject:@"Martin Luther King Day" forKey:DateForDayMonthYear(19, 1, 2009)];
  [holidays setObject:@"Washington's Birthday" forKey:DateForDayMonthYear(16, 2, 2009)];
  [holidays setObject:@"Memorial Day" forKey:DateForDayMonthYear(25, 5, 2009)];
  [holidays setObject:@"Independence Day" forKey:DateForDayMonthYear(4, 7, 2009)];
  [holidays setObject:@"Labor Day" forKey:DateForDayMonthYear(7, 9, 2009)];
  [holidays setObject:@"Columbus Day" forKey:DateForDayMonthYear(12, 10, 2009)];
  [holidays setObject:@"Veteran's Day" forKey:DateForDayMonthYear(11, 11, 2009)];
  [holidays setObject:@"Thanksgiving Day" forKey:DateForDayMonthYear(26, 11, 2009)];
  [holidays setObject:@"Today! (testing)" forKey:DateForDayMonthYear(19, 12, 2009)];
  [holidays setObject:@"Christmas Day" forKey:DateForDayMonthYear(25, 12, 2009)];
  [holidays setObject:@"New Years Day" forKey:DateForDayMonthYear(1, 1, 2010)];
  [holidays setObject:@"Martin Luther King Day" forKey:DateForDayMonthYear(18, 1, 2010)];
  [holidays setObject:@"Washington's Birthday" forKey:DateForDayMonthYear(15, 2, 2010)];
  [holidays setObject:@"Memorial Day" forKey:DateForDayMonthYear(31, 5, 2010)];
  [holidays setObject:@"Independence Day" forKey:DateForDayMonthYear(4, 7, 2010)];
  [holidays setObject:@"Labor Day" forKey:DateForDayMonthYear(6, 9, 2010)];
  [holidays setObject:@"Columbus Day" forKey:DateForDayMonthYear(11, 10, 2010)];
  [holidays setObject:@"Veteran's Day" forKey:DateForDayMonthYear(11, 11, 2010)];
  [holidays setObject:@"Thanksgiving Day" forKey:DateForDayMonthYear(25, 11, 2010)];
  [holidays setObject:@"Christmas Day" forKey:DateForDayMonthYear(25, 12, 2010)];
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

- (void)loadDate:(NSDate *)date;
{
  [items removeAllObjects];
  NSString *item = [holidays objectForKey:date];
  if (item)
    [items addObject:item];
}

- (BOOL)hasDetailsForDate:(NSDate *)date
{
  return [holidays objectForKey:date] != nil;
}

- (void)dealloc
{
  [items release];
  [super dealloc];
}


@end
