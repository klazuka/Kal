/*
 * Copyright (c) 2010 Keith Lazuka
 * License: http://www.opensource.org/licenses/mit-license.html
 */

#import "Kal.h"

@class EKEventStore, EKEvent;

@interface EventKitDataSource : NSObject <KalDataSource>
{
  EKEventStore *eventStore;
  NSMutableArray *items;
  NSMutableArray *events;
}

+ (EventKitDataSource *)dataSource;
- (EKEvent *)eventAtIndexPath:(NSIndexPath *)indexPath;  // exposed for client so that it can implement the UITableViewDelegate protocol.

@end
