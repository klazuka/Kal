@class KalGridView, KalLogic;
@protocol KalViewDelegate;

/*
 *    KalView
 *    ------------------
 *
 *    Private interface
 *
 *  As a client of the Kal system you should not need to use this class directly
 *  (it is managed by KalViewController).
 *
 *  KalViewController uses KalView as its view.
 *  KalView defines a view hierarchy that looks like the following:
 *
 *       +-----------------------------------------+
 *       |                header view              |
 *       +-----------------------------------------+
 *       |                                         |
 *       |                                         |
 *       |                                         |
 *       |                 grid view               |
 *       |             (the calendar grid)         |
 *       |                                         |
 *       |                                         |
 *       +-----------------------------------------+
 *       |                                         |
 *       |           table view (events)           |
 *       |                                         |
 *       +-----------------------------------------+
 *
 */
@interface KalView : UIView
{
  UILabel *headerTitleLabel;    // Displays the currently selected month and year at the top of the calendar.
  KalGridView *gridView;        // The calendar proper (between the calendar header and the table view)
  UITableView *tableView;       // Bottom section (events for the currently selected day)
  id<KalViewDelegate> delegate;
  KalLogic *logic;
}

@property (nonatomic, assign) id<KalViewDelegate> delegate;
@property (nonatomic, readonly) UITableView *tableView;

- (id)initWithFrame:(CGRect)frame delegate:(id<KalViewDelegate>)delegate logic:(KalLogic *)logic;

- (void)refresh;  // Requery marked tiles and update the table view of events.

// These 2 methods are exposed for the delegate. They should be called 
// *after* the KalLogic has moved to the previous or following month.
- (void)slideDown;
- (void)slideUp;

@end

#pragma mark -

/* This protocol will, in most cases, be implemented by a view controller. */

@protocol KalViewDelegate

- (void)showPreviousMonth;
- (void)showFollowingMonth;
- (BOOL)shouldMarkTileForDate:(NSDate *)date;
- (void)didSelectDate:(NSDate *)date;

@end
