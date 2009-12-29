/* 
 * Copyright (c) 2009 Keith Lazuka
 * License: http://www.opensource.org/licenses/mit-license.html
 */

@protocol KalViewDelegate;
@class KalTileView;

@interface KalMonthView : UIView
{
  id<KalViewDelegate> delegate;
  NSUInteger numWeeks;
}

@property (nonatomic) NSUInteger numWeeks;

- (id)initWithFrame:(CGRect)rect delegate:(id<KalViewDelegate>)delegate; // designated initializer

- (void)showDates:(NSArray *)mainDates beginShared:(NSArray *)firstWeekShared endShared:(NSArray *)finalWeekShared;
- (KalTileView *)todaysTileIfVisible;

@end
