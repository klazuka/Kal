/* 
 * Copyright (c) 2009 Keith Lazuka
 * License: http://www.opensource.org/licenses/mit-license.html
 */

#import "Kal.h"

@interface HolidayCalendarDataSource : NSObject <KalDataSource>
{
  NSMutableArray *items;
  NSMutableArray *holidays;
  NSMutableData *buffer;
  id<KalDataSourceCallbacks> callback;
  BOOL dataReady;
}

+ (HolidayCalendarDataSource *)dataSource;

@end
