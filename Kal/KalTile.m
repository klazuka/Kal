/* 
 * Copyright (c) 2009 Keith Lazuka
 * License: http://www.opensource.org/licenses/mit-license.html
 */

#import "KalTile.h"


@implementation KalTile

@synthesize date, selected=isSelected, highlighted=isHighlighted, marked=isMarked, type;

- (void)resetState
{
  [date release];
  date = nil;
  type = KalTileTypeRegular;
  isHighlighted = NO;
  isSelected = NO;
  isMarked = NO;
}

- (BOOL)isToday { return type == KalTileTypeToday; }

- (BOOL)belongsToAdjacentMonth { return type == KalTileTypeAdjacent; }

- (void)dealloc
{
  [date release];
  [super dealloc];
}


@end
