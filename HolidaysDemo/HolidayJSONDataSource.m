/*
 * Copyright (c) 2009 Keith Lazuka
 * License: http://www.opensource.org/licenses/mit-license.html
 */

#import "JSON/JSON.h"

#import "HolidayJSONDataSource.h"
#import "Holiday.h"

static BOOL IsDateBetweenInclusive(NSDate *date, NSDate *begin, NSDate *end)
{
  return [date compare:begin] != NSOrderedAscending && [date compare:end] != NSOrderedDescending;
}

@interface HolidayJSONDataSource ()
- (NSArray *)holidaysFrom:(NSDate *)fromDate to:(NSDate *)toDate;
- (NSArray *)markedDatesFrom:(NSDate *)fromDate to:(NSDate *)toDate;
@end

@implementation HolidayJSONDataSource

+ (HolidayJSONDataSource *)dataSource
{
  return [[[[self class] alloc] init] autorelease];
}

- (id)init
{
  if ((self = [super init])) {
    items = [[NSMutableArray alloc] init];
    holidays = [[NSMutableArray alloc] init];
    buffer = [[NSMutableData alloc] init];
  }
  return self;
}

- (Holiday *)holidayAtIndexPath:(NSIndexPath *)indexPath
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

  Holiday *holiday = [self holidayAtIndexPath:indexPath];
  cell.imageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"flags/%@.gif", holiday.country]];
  cell.textLabel.text = holiday.name;
  return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
  return [items count];
}

#pragma mark Fetch from the internet

- (void)fetchHolidays
{
  NSString *path = @"http://keith.lazuka.org/holidays.json";
  NSLog(@"Fetching %@", path);
  dataReady = NO;
  [holidays removeAllObjects];
  NSURLConnection *conn = [NSURLConnection connectionWithRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:path]] delegate:self];
  [conn start];
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
  [buffer setLength:0];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
  [buffer appendData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
  NSString *str = [[[NSString alloc] initWithData:buffer encoding:NSUTF8StringEncoding] autorelease];
  NSArray *array = [str JSONValue];
  if (!array)
    return;
  
  NSDateFormatter *fmt = [[[NSDateFormatter alloc] init] autorelease];
  [fmt setDateFormat:@"yyyy-MM-dd"];
  for (NSDictionary *dict in array) {
    NSDate *d = [fmt dateFromString:[dict objectForKey:@"date"]];
    [holidays addObject:[Holiday holidayNamed:[dict objectForKey:@"name"] country:[dict objectForKey:@"country"] date:d]];
  }
  
  dataReady = YES;
  [callback loadedDataSource:self];
}

-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
  NSLog(@"HolidaysCalendarDataSource connection failure: %@", error);
}

#pragma mark KalDataSource protocol conformance

- (void)presentingDatesFrom:(NSDate *)fromDate to:(NSDate *)toDate delegate:(id<KalDataSourceCallbacks>)delegate
{
  /* 
   * In this example, I load the entire dataset in one HTTP request, so the date range that is 
   * being presented is irrelevant. So all I need to do is make sure that the data is loaded
   * the first time and that I always issue the callback to complete the asynchronous request
   * (even in the trivial case where we are responding synchronously).
   */
  
  if (dataReady) {
    [callback loadedDataSource:self];
    return;
  }
  
  callback = delegate;
  [self fetchHolidays];
}

- (NSArray *)markedDatesFrom:(NSDate *)fromDate to:(NSDate *)toDate
{
  if (!dataReady)
    return [NSArray array];
  
  return [[self holidaysFrom:fromDate to:toDate] valueForKeyPath:@"date"];
}

- (void)loadItemsFromDate:(NSDate *)fromDate toDate:(NSDate *)toDate
{
  if (!dataReady)
    return;
  
  [items addObjectsFromArray:[self holidaysFrom:fromDate to:toDate]];
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

- (void)dealloc
{
  [items release];
  [holidays release];
  [buffer release];
  [super dealloc];
}

@end
