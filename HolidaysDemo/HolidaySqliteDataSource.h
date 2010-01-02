/* 
 * Copyright (c) 2009 Keith Lazuka
 * License: http://www.opensource.org/licenses/mit-license.html
 */

#import "Kal.h"

@interface HolidaySqliteDataSource : NSObject <KalDataSource>
{
  NSMutableArray *items;
  NSMutableArray *holidays;
}

+ (HolidaySqliteDataSource *)dataSource;

@end
