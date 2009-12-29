/* 
 * Copyright (c) 2009 Keith Lazuka
 * License: http://www.opensource.org/licenses/mit-license.html
 */

#define MAX_NUM_TILES (6*7)

@protocol KalViewDelegate;
@class KalTile;

@interface KalMonthView : UIView
{
  id<KalViewDelegate> delegate;
  KalTile *tiles[MAX_NUM_TILES];
  NSUInteger numWeeks;
  BOOL isFirstWeekShared;
  BOOL isFinalWeekShared;
}

@property (nonatomic) NSUInteger numWeeks;

- (id)initWithFrame:(CGRect)rect delegate:(id<KalViewDelegate>)delegate; // designated initializer

- (void)showDates:(NSArray *)mainDates beginShared:(NSArray *)firstWeekShared endShared:(NSArray *)finalWeekShared;
- (KalTile *)hitTileTest:(CGPoint)location;
- (KalTile *)todaysTileIfVisible;

@end
