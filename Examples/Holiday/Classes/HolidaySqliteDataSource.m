/*
 * Copyright (c) 2009 Keith Lazuka
 * License: http://www.opensource.org/licenses/mit-license.html
 */

#import <sqlite3.h>

#import "HolidaySqliteDataSource.h"
#import "Holiday.h"

static BOOL IsDateBetweenInclusive(NSDate *date, NSDate *begin, NSDate *end)
{
  return [date compare:begin] != NSOrderedAscending && [date compare:end] != NSOrderedDescending;
}

@interface HolidaySqliteDataSource ()
- (NSArray *)holidaysFrom:(NSDate *)fromDate to:(NSDate *)toDate;
@end

@implementation HolidaySqliteDataSource

+ (HolidaySqliteDataSource *)dataSource
{
  return [[[[self class] alloc] init] autorelease];
}

- (id)init
{
  if ((self = [super init])) {
    items = [[NSMutableArray alloc] init];
    holidays = [[NSMutableArray alloc] init];
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

#pragma mark Sqlite access

- (NSString *)databasePath
{
  return [[NSBundle mainBundle] pathForResource:@"holidays" ofType:@"db"];
}

- (void)loadHolidaysFrom:(NSDate *)fromDate to:(NSDate *)toDate delegate:(id<KalDataSourceCallbacks>)delegate
{
  NSLog(@"Fetching holidays from the database between %@ and %@...", fromDate, toDate);
	sqlite3 *db;
  NSDateFormatter *fmt = [[[NSDateFormatter alloc] init] autorelease];
  
	if(sqlite3_open([[self databasePath] UTF8String], &db) == SQLITE_OK) {
		const char *sql = "select name, country, date_of_event from holidays where date_of_event between ? and ?";
		sqlite3_stmt *stmt;
		if(sqlite3_prepare_v2(db, sql, -1, &stmt, NULL) == SQLITE_OK) {
      [fmt setDateFormat:@"yyyy-MM-dd hh:mm:ss"];
      sqlite3_bind_text(stmt, 1, [[fmt stringFromDate:fromDate] UTF8String], -1, SQLITE_STATIC);
      sqlite3_bind_text(stmt, 2, [[fmt stringFromDate:toDate] UTF8String], -1, SQLITE_STATIC);
      [fmt setDateFormat:@"yyyy-MM-dd"];
			while(sqlite3_step(stmt) == SQLITE_ROW) {
				NSString *name = [NSString stringWithUTF8String:(char *)sqlite3_column_text(stmt, 0)];
				NSString *country = [NSString stringWithUTF8String:(char *)sqlite3_column_text(stmt, 1)];
        NSString *dateAsText = [NSString stringWithUTF8String:(char *)sqlite3_column_text(stmt, 2)];
        [holidays addObject:[Holiday holidayNamed:name country:country date:[fmt dateFromString:dateAsText]]];
			}
		}
		sqlite3_finalize(stmt);
	}
	sqlite3_close(db);
  [delegate loadedDataSource:self];
}

#pragma mark KalDataSource protocol conformance

- (void)presentingDatesFrom:(NSDate *)fromDate to:(NSDate *)toDate delegate:(id<KalDataSourceCallbacks>)delegate
{
  [holidays removeAllObjects];
  [self loadHolidaysFrom:fromDate to:toDate delegate:delegate];
}

- (NSArray *)markedDatesFrom:(NSDate *)fromDate to:(NSDate *)toDate
{
  return [[self holidaysFrom:fromDate to:toDate] valueForKeyPath:@"date"];
}

- (void)loadItemsFromDate:(NSDate *)fromDate toDate:(NSDate *)toDate
{
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
  [super dealloc];
}

@end
