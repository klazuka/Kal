/* 
 * Copyright (c) 2009 Keith Lazuka
 * License: http://www.opensource.org/licenses/mit-license.html
 */

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
  UILabel *headerTitleLabel;
  KalGridView *gridView;
  UITableView *tableView;
  id<KalViewDelegate> delegate;
  KalLogic *logic;
}

@property (nonatomic, assign) id<KalViewDelegate> delegate;
@property (nonatomic, readonly) UITableView *tableView;

- (id)initWithFrame:(CGRect)frame delegate:(id<KalViewDelegate>)delegate logic:(KalLogic *)logic;

// These 3 methods are exposed for the delegate. They should be called 
// *after* the KalLogic has moved to the previous or following month.
- (void)slideDown;
- (void)slideUp;
- (void)jumpToSelectedMonth;    // change months without animation (i.e. when directly switching to "Today")

- (BOOL)isSliding;
- (void)selectTodayIfVisible;

@end

#pragma mark -

@protocol KalViewDelegate

- (void)showPreviousMonth;
- (void)showFollowingMonth;
- (BOOL)shouldMarkTileForDate:(NSDate *)date;
- (void)didSelectDate:(NSDate *)date;

@end
