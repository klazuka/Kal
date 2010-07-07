/*
 * Copyright (c) 2010 Keith Lazuka
 * License: http://www.opensource.org/licenses/mit-license.html
 */

#import "EventKitDataSource.h"
#import <EventKit/EventKit.h>

static BOOL IsDateBetweenInclusive(NSDate *date, NSDate *begin, NSDate *end)
{
  return [date compare:begin] != NSOrderedAscending && [date compare:end] != NSOrderedDescending;
}

@interface EventKitDataSource ()
- (NSArray *)eventsFrom:(NSDate *)fromDate to:(NSDate *)toDate;
- (NSArray *)markedDatesFrom:(NSDate *)fromDate to:(NSDate *)toDate;
@end

@implementation EventKitDataSource

+ (EventKitDataSource *)dataSource
{
  return [[[[self class] alloc] init] autorelease];
}

- (id)init
{
  if ((self = [super init])) {
    eventStore = [[EKEventStore alloc] init];
    events = [[NSMutableArray alloc] init];
    items = [[NSMutableArray alloc] init];
  }
  return self;
}

- (EKEvent *)eventAtIndexPath:(NSIndexPath *)indexPath
{
  return [items objectAtIndex:indexPath.row];
}

#pragma mark UITableViewDataSource protocol conformance

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  static NSString *identifier = @"MyCell";
  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
  if (!cell) {
    cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier] autorelease];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.imageView.contentMode = UIViewContentModeScaleAspectFill;
  }

  EKEvent *event = [self eventAtIndexPath:indexPath];
  cell.textLabel.text = event.title;
  return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
  return [items count];
}

#pragma mark KalDataSource protocol conformance

- (void)presentingDatesFrom:(NSDate *)fromDate to:(NSDate *)toDate delegate:(id<KalDataSourceCallbacks>)delegate
{
  [events removeAllObjects];
  NSLog(@"Fetching events from EventKit between %@ and %@...", fromDate, toDate);
  NSPredicate *predicate = [eventStore predicateForEventsWithStartDate:fromDate endDate:toDate calendars:nil];
  [events addObjectsFromArray:[eventStore eventsMatchingPredicate:predicate]];
  [delegate loadedDataSource:self];
}

- (NSArray *)markedDatesFrom:(NSDate *)fromDate to:(NSDate *)toDate
{
  return [[self eventsFrom:fromDate to:toDate] valueForKeyPath:@"startDate"];
}

- (void)loadItemsFromDate:(NSDate *)fromDate toDate:(NSDate *)toDate
{
  [items addObjectsFromArray:[self eventsFrom:fromDate to:toDate]];
}

- (void)removeAllItems
{
  [items removeAllObjects];
}

#pragma mark -

- (NSArray *)eventsFrom:(NSDate *)fromDate to:(NSDate *)toDate
{
  NSMutableArray *matches = [NSMutableArray array];
  for (EKEvent *event in events)
    if (IsDateBetweenInclusive(event.startDate, fromDate, toDate))
      [matches addObject:event];
  
  return matches;
}

- (void)dealloc
{
  [eventStore release];
  [items release];
  [events release];
  [super dealloc];
}

@end
