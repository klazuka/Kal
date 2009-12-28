/* 
 * Copyright (c) 2009 Keith Lazuka
 * License: http://www.opensource.org/licenses/mit-license.html
 */

enum {
  KalTileTypeRegular   = 0,
  KalTileTypeAdjacent  = 1 << 0,
  KalTileTypeToday     = 1 << 1,
};
typedef NSUInteger KalTileType;

@interface KalTile : NSObject
{
  NSDate *date;
  BOOL isHighlighted;
  BOOL isSelected;
  KalTileType type;
}

@property (nonatomic, retain) NSDate *date;
@property (nonatomic, getter=isHighlighted) BOOL highlighted;
@property (nonatomic, getter=isSelected) BOOL selected;
@property (nonatomic) KalTileType type;

- (void)resetState;
- (BOOL)isToday;
- (BOOL)belongsToAdjacentMonth;


@end
