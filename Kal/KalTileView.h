/* 
 * Copyright (c) 2009 Keith Lazuka
 * License: http://www.opensource.org/licenses/mit-license.html
 */

enum {
  KalTileTypeRegular   = 0,
  KalTileTypeAdjacent  = 1 << 0,
  KalTileTypeToday     = 1 << 1,
};
typedef char KalTileType;

@interface KalTileView : UIView
{
  NSDate *date;
  UILabel *dayLabel;
  UIImageView *backgroundView;
  UIImageView *markerView;
  BOOL isHighlighted;
  BOOL isSelected;
  BOOL isMarked;
  KalTileType type;
  CGPoint origin;
}

@property (nonatomic, retain) NSDate *date;
@property (nonatomic, getter=isHighlighted) BOOL highlighted;
@property (nonatomic, getter=isSelected) BOOL selected;
@property (nonatomic, getter=isMarked) BOOL marked;
@property (nonatomic) KalTileType type;

- (void)resetState;
- (BOOL)isToday;
- (BOOL)belongsToAdjacentMonth;


@end
