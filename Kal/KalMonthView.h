/* 
 * Copyright (c) 2009 Keith Lazuka
 * License: http://www.opensource.org/licenses/mit-license.html
 */

@class KalTileView, KalDate;

@interface KalMonthView : UIView
{
  KalDate *fromDate;
  KalDate *toDate;
  NSUInteger numWeeks;
}

@property (nonatomic, retain) KalDate *fromDate;
@property (nonatomic, retain) KalDate *toDate;
@property (nonatomic) NSUInteger numWeeks;

- (id)initWithFrame:(CGRect)rect; // designated initializer
- (void)showDates:(NSArray *)mainDates leadingAdjacentDates:(NSArray *)leadingAdjacentDates trailingAdjacentDates:(NSArray *)trailingAdjacentDates;
- (KalTileView *)todaysTileIfVisible;
- (KalTileView *)firstTileOfMonth;
- (KalTileView *)tileForDate:(KalDate *)date;
- (void)markTilesForDates:(NSArray *)dates;

@end
