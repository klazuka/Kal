/* 
 * Copyright (c) 2009 Keith Lazuka
 * License: http://www.opensource.org/licenses/mit-license.html
 */


/*
 *    KalLogic
 *    ------------------
 *
 *    Private interface
 *
 *  As a client of the Kal system you should not need to use this class directly
 *  (it is managed by the internal Kal subsystem).
 *
 *  The KalLogic represents the current state of the displayed calendar month
 *  and provides the logic for switching between months and determining which days
 *  are in a month as well as which days are in partial weeks adjacent to the selected
 *  month.
 */
@interface KalLogic : NSObject
{
  NSDate *baseDate; // The first day of the currently selected month
  NSDateFormatter *monthAndYearFormatter;
}

@property (nonatomic, retain) NSDate *baseDate;

- (void)retreatToPreviousMonth;
- (void)advanceToFollowingMonth;
- (void)moveToTodaysMonth;

- (NSArray *)daysInFinalWeekOfPreviousMonth;
- (NSArray *)daysInSelectedMonth;
- (NSArray *)daysInFirstWeekOfFollowingMonth;

- (NSString *)selectedMonthNameAndYear;

@end
