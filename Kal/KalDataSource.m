/* 
 * Copyright (c) 2009 Keith Lazuka
 * License: http://www.opensource.org/licenses/mit-license.html
 */

#import "KalDataSource.h"
#import "KalPrivate.h"

@implementation SimpleKalDataSource

+ (SimpleKalDataSource*)dataSource
{
  return [[[[self class] alloc] init] autorelease];
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
  
  cell.textLabel.text = @"Filler text";
  return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
  return 0;
}

#pragma mark KalDataSource protocol conformance

- (void)fetchMarkedDatesFrom:(NSDate *)fromDate to:(NSDate *)toDate delegate:(id<KalDataSourceCallbacks>)delegate
{
  [delegate finishedFetchingMarkedDates:[NSArray array]];
}

- (void)loadItemsFromDate:(NSDate *)fromDate toDate:(NSDate *)toDate delegate:(id<KalDataSourceCallbacks>)delegate
{
  [delegate finishedLoadingItems];
}

- (void)removeAllItems
{
  // do nothing
}

@end
