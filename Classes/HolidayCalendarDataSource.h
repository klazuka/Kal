//
//  HolidayCalendarDataSource.h
//  Kal
//
//  Created by Keith Lazuka on 7/22/09.
//  Copyright 2009 The Polypeptides. All rights reserved.
//

#import "KalDataSource.h"

@interface HolidayCalendarDataSource : NSObject <KalDataSource>
{
  NSMutableArray *items;
}

+ (HolidayCalendarDataSource *)dataSource;

@end
