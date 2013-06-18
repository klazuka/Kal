/*
 * Copyright (c) 2009 Keith Lazuka
 * License: http://www.opensource.org/licenses/mit-license.html
 */

#import "Kal.h"

@class Holiday;

/*
 *    HolidayJSONDataSource
 *    ---------------------
 *
 *  This example data source retrieves world holidays
 *  from a JSON resource located at http://keith.lazuka.org/holidays.json.
 *  It uses Stig Brautaset's JSON library to parse the JSON and store
 *  it in an array of Holiday objects.
 *
 */
@interface HolidayJSONDataSource : NSObject <KalDataSource>
{
  NSMutableArray *items;
  NSMutableArray *holidays;
  NSMutableData *buffer;
  id<KalDataSourceCallbacks> callback;
  BOOL dataReady;
}

+ (HolidayJSONDataSource *)dataSource;
- (Holiday *)holidayAtIndexPath:(NSIndexPath *)indexPath;  // exposed for HolidayAppDelegate so that it can implement the UITableViewDelegate protocol.

@end
