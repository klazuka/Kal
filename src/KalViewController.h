/* 
 * Copyright (c) 2009 Keith Lazuka
 * License: http://www.opensource.org/licenses/mit-license.html
 */

#import <UIKit/UIKit.h>
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
  id <UITableViewDelegate> delegate;
  id <KalDataSource> dataSource;
  NSDate *initialSelectedDate;
}

@property (nonatomic, assign) id<UITableViewDelegate> delegate;
@property (nonatomic, assign) id<KalDataSource> dataSource;

- (id)initWithSelectedDate:(NSDate *)selectedDate;  // designated initializer. When the calendar is first displayed to the user, the month that contains 'selectedDate' will be shown and the corresponding tile for 'selectedDate' will be automatically selected.
- (void)reloadData;                                 // If you change the KalDataSource after the KalViewController has already been displayed to the user, you must call this method in order for the view to reflect the new data.
- (void)showAndSelectDate:(NSDate *)date;           // Updates the state of the calendar to display the specified date's month and selects the tile for that date.
- (NSDate *)selectedDate;                           // The currently selected date. You should only use the actual date components from this NSDate object. The hours/minutes/seconds/timezones are undefined.

@end
