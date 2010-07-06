/*
 * Copyright (c) 2009 Keith Lazuka
 * License: http://www.opensource.org/licenses/mit-license.html
 */

@class Holiday;

/*
 *    HolidaysDetailViewController
 *    ----------------------------
 *
 *  This view controller will be pushed onto the navigation stack
 *  when the user taps the row for a holiday beneath the calendar.
 */
@interface HolidaysDetailViewController : UIViewController
{
  Holiday *holiday;
}

- (id)initWithHoliday:(Holiday *)holiday;

@end
