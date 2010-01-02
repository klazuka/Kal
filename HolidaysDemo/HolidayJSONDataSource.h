/* 
 * Copyright (c) 2009 Keith Lazuka
 * License: http://www.opensource.org/licenses/mit-license.html
 */

#import "Kal.h"

@interface HolidayJSONDataSource : NSObject <KalDataSource>
{
  NSMutableArray *items;
  NSMutableArray *holidays;
  NSMutableData *buffer;
  id<KalDataSourceCallbacks> callback;
  BOOL dataReady;
}

+ (HolidayJSONDataSource *)dataSource;

@end
