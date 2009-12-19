/* 
 * Copyright (c) 2009 Keith Lazuka
 * License: http://www.opensource.org/licenses/mit-license.html
 */

#import "KalDataSource.h"

@interface HolidayCalendarDataSource : NSObject <KalDataSource>
{
  NSMutableArray *items;
}

+ (HolidayCalendarDataSource *)dataSource;

@end
