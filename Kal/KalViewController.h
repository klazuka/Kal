/* 
 * Copyright (c) 2009 Keith Lazuka
 * License: http://www.opensource.org/licenses/mit-license.html
 */

#import "KalView.h"       // for the KalViewDelegate protocol
#import "KalDataSource.h" // for the KalDataSourceCallbacks protocol

@class KalLogic, KalDate;

/*
 *    KalViewController
 *    ------------------------
 *
 *  KalViewController automatically creates both the calendar view
 *  and the events table view for you. The only thing you need to provide
 *  is a KalDataSource so that the calendar system knows which days to
 *  mark with a dot and which events to list under the calendar when a certain
 *  date is selected (just like in Apple's calendar app).
 *
 */
@interface KalViewController : UIViewController <KalViewDelegate, KalDataSourceCallbacks>
{
  KalLogic *logic;
  UITableView *tableView;
  id <KalDataSource> dataSource;
}

@property (nonatomic, readonly) KalView *calendarView;
@property (nonatomic, readonly) UITableView *tableView;

- (id)initWithDataSource:(id<KalDataSource>)source; // designated initializer
- (void)showAndSelectToday; // Updates the state of the calendar to display today's month and selects the tile for today's date.

@end
