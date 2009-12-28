/* 
 * Copyright (c) 2009 Keith Lazuka
 * License: http://www.opensource.org/licenses/mit-license.html
 */

#import <CoreGraphics/CoreGraphics.h>
#import "KalMonthView.h"
#import "KalTile.h"
#import "KalPrivate.h"

extern const CGSize kTileSize;

@implementation KalMonthView

@synthesize numWeeks;

- (id)initWithFrame:(CGRect)frame
{
  if ((self = [super initWithFrame:frame])) {
    self.opaque = NO;
    for (int i=0; i<MAX_NUM_TILES; i++)
      tiles[i] = [[KalTile alloc] init];
  }
  return self;
}

- (void)showDates:(NSArray *)mainDates beginShared:(NSArray *)firstWeekShared endShared:(NSArray *)finalWeekShared
{
  int i = 0;
  
  for (NSDate *d in firstWeekShared) {
    KalTile *tile = tiles[i];
    [tile resetState];
    tile.type = KalTileTypeAdjacent;
    tile.date = d;
    i++;
  }
  
  for (NSDate *d in mainDates) {
    // TODO: query delegate for marked days
    KalTile *tile = tiles[i];
    [tile resetState];
    tile.type = [d cc_isToday] ? KalTileTypeToday : KalTileTypeRegular;
    tile.date = d;
    i++;
  }
  
  for (NSDate *d in finalWeekShared) {
    KalTile *tile = tiles[i];
    [tile resetState];
    tile.type = KalTileTypeAdjacent;
    tile.date = d;
    i++;
  }
  
  numWeeks = ceilf(i / 7.f);
  [self sizeToFit];
  [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect
{
  // TODO
  //  - draw selected tile
  //  - draw hover adjacent tile 
  //  - draw marker
  
  CGContextRef ctx = UIGraphicsGetCurrentContext();
  CGContextDrawTiledImage(ctx, (CGRect){CGPointZero,kTileSize}, [[UIImage imageNamed:@"kal_tile.png"] CGImage]);
  
  [[UIColor blackColor] setFill];
  CGFloat fontSize = 21.f;
  CGContextSelectFont(ctx, [[[UIFont boldSystemFontOfSize:fontSize] fontName] cStringUsingEncoding:NSUTF8StringEncoding], fontSize, kCGEncodingMacRoman);
  char day[3];
  for (int i=0; i<numWeeks; i++) {
    for (int j=0; j<7; j++) {
      KalTile *tile = tiles[j+i*7];
      
      if ([tile isToday]) {
        [[[UIImage imageNamed:@"kal_tiletoday.png"] stretchableImageWithLeftCapWidth:6 topCapHeight:0] drawInRect:CGRectMake(j*kTileSize.width - 1, i*kTileSize.height, kTileSize.width + 1, kTileSize.height + 1)];
      }      
      
      NSUInteger n = [tile.date cc_day];
      sprintf(day, "%lu", (unsigned long)n);
      CGContextSaveGState(ctx);
      CGContextTranslateCTM(ctx, j*kTileSize.width, (i+1)*kTileSize.height);
      CGContextScaleCTM(ctx, 1, -1);
      CGContextShowTextAtPoint(ctx, 0, 0, day, n >= 10 ? 2 : 1);
      CGContextRestoreGState(ctx);
    }
  }
}

- (void)sizeToFit
{
  self.height = kTileSize.height * numWeeks;
}

- (void)dealloc
{
  for (int i=0; i<MAX_NUM_TILES; i++)
    [tiles[i] release];
  
  [super dealloc];
}


@end
