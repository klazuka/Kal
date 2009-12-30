/* 
 * Copyright (c) 2009 Keith Lazuka
 * License: http://www.opensource.org/licenses/mit-license.html
 */

#import <CoreGraphics/CoreGraphics.h>
#import "KalMonthView.h"
#import "KalTileView.h"
#import "KalView.h"
#import "KalDate.h"
#import "KalPrivate.h"

extern const CGSize kTileSize;

@implementation KalMonthView

@synthesize numWeeks;

- (id)initWithFrame:(CGRect)frame delegate:(id<KalViewDelegate>)theDelegate
{
  if ((self = [super initWithFrame:frame])) {
    delegate = theDelegate;
    self.opaque = NO;
    self.clipsToBounds = YES;
    for (int i=0; i<6; i++) {
      for (int j=0; j<7; j++) {
        CGRect r = CGRectMake(j*kTileSize.width, i*kTileSize.height, kTileSize.width, kTileSize.height);
        [self addSubview:[[[KalTileView alloc] initWithFrame:r] autorelease]];
      }
    }
  }
  return self;
}

- (id)initWithFrame:(CGRect)frame
{
  [NSException raise:@"Invalid initializer" format:@"KalMonthView must be instantiated with a delegate"];
  return nil;
}

- (void)showDates:(NSArray *)mainDates beginShared:(NSArray *)firstWeekShared endShared:(NSArray *)finalWeekShared
{
  int i = 0;
  
  KalDate *fromDate = [firstWeekShared count] > 0 ? [firstWeekShared objectAtIndex:0] : [mainDates objectAtIndex:0];
  KalDate *toDate = [finalWeekShared count] > 0 ? [finalWeekShared lastObject] : [mainDates lastObject];
  NSArray *markedDates = [delegate markedDatesFrom:fromDate to:toDate];
  
  for (KalDate *d in firstWeekShared) {
    KalTileView *tile = [self.subviews objectAtIndex:i];
    [tile resetState];
    tile.type = KalTileTypeAdjacent;
    tile.date = d;
    tile.marked = [markedDates containsObject:d];
    [tile setNeedsDisplay];
    i++;
  }
  
  for (KalDate *d in mainDates) {
    KalTileView *tile = [self.subviews objectAtIndex:i];
    [tile resetState];
    tile.type = [d isToday] ? KalTileTypeToday : KalTileTypeRegular;
    tile.date = d;
    tile.marked = [markedDates containsObject:d];
    [tile setNeedsDisplay];
    i++;
  }
  
  for (KalDate *d in finalWeekShared) {
    KalTileView *tile = [self.subviews objectAtIndex:i];
    [tile resetState];
    tile.type = KalTileTypeAdjacent;
    tile.date = d;
    tile.marked = [markedDates containsObject:d];
    [tile setNeedsDisplay];
    i++;
  }
  
  numWeeks = ceilf(i / 7.f);
  [self sizeToFit];
  [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect
{
  CGContextRef ctx = UIGraphicsGetCurrentContext();
  CGContextDrawTiledImage(ctx, (CGRect){CGPointZero,kTileSize}, [[UIImage imageNamed:@"kal_tile.png"] CGImage]);
}

- (KalTileView *)todaysTileIfVisible
{
  KalTileView *tile = nil;
  for (KalTileView *t in self.subviews) {
    if ([t isToday]) {
      tile = t;
      break;
    }
  }
  
  return tile;
}

- (KalTileView *)firstTileOfMonth
{
  KalTileView *tile = nil;
  for (KalTileView *t in self.subviews) {
    if (!t.belongsToAdjacentMonth) {
      tile = t;
      break;
    }
  }
  
  return tile;
}

- (KalTileView *)tileForDate:(KalDate *)date
{
  KalTileView *tile = nil;
  for (KalTileView *t in self.subviews) {
    if ([t.date isEqual:date]) {
      tile = t;
      break;
    }
  }
  
  return tile;
}

- (void)sizeToFit
{
  self.height = 1.f + kTileSize.height * numWeeks;
}

@end
