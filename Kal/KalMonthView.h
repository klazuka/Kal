/* 
 * Copyright (c) 2009 Keith Lazuka
 * License: http://www.opensource.org/licenses/mit-license.html
 */

#define MAX_NUM_TILES (6*7)

@class KalTile;

@interface KalMonthView : UIView
{
  KalTile *tiles[MAX_NUM_TILES];
  NSUInteger numWeeks;
  BOOL isFirstWeekShared;
  BOOL isFinalWeekShared;
}

@property (nonatomic) NSUInteger numWeeks;

- (void)showDates:(NSArray *)mainDates beginShared:(NSArray *)firstWeekShared endShared:(NSArray *)finalWeekShared;

@end
