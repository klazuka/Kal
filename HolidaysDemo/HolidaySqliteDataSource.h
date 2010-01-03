/*
 * Copyright (c) 2009 Keith Lazuka
 * License: http://www.opensource.org/licenses/mit-license.html
 */

#import "Kal.h"

/*
 *    HolidaySqliteDataSource
 *    ---------------------
 *
 *  This example data source retrieves 2009 and 2010 world holidays
 *  from an Sqlite database stored locally in the application bundle.
 *  When the presentingDatesFrom:to:delegate message is received,
 *  it queries the database for the specified date range and
 *  instantiates a Holiday object for each row in the result set.
 *
 */
@interface HolidaySqliteDataSource : NSObject <KalDataSource>
{
  NSMutableArray *items;
  NSMutableArray *holidays;
}

+ (HolidaySqliteDataSource *)dataSource;

@end
