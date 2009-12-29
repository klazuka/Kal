/* 
 * Copyright (c) 2009 Keith Lazuka
 * License: http://www.opensource.org/licenses/mit-license.html
 */

#import "KalTileView.h"
#import "KalPrivate.h"

extern const CGSize kTileSize;

@interface KalTileView ()
- (void)reloadStyle;
- (void)addBackground;
- (void)addDayLabel;
- (void)addMarkerView;
@end

@implementation KalTileView

@synthesize date, selected=isSelected, highlighted=isHighlighted, marked=isMarked, type;

- (id)initWithFrame:(CGRect)frame
{
  if ((self = [super initWithFrame:frame])) {
    self.opaque = NO;
    self.backgroundColor = [UIColor clearColor];
    self.clipsToBounds = NO;
    [self resetState];
    [self addBackground];
    [self addDayLabel];
    [self addMarkerView];
  }
  return self;
}

- (void)drawRect:(CGRect)rect
{
  [self reloadStyle];
  [super drawRect:rect];
}

- (void)addMarkerView
{
  CGRect frame = self.frame;
  frame.origin = CGPointMake(21.f, 35.f);
  frame.size = CGSizeMake(4.f, 5.f);
  
  markerView = [[UIImageView alloc] initWithFrame:frame];
  markerView.contentMode = UIViewContentModeCenter;
  [self addSubview:markerView];
}

- (void)addBackground
{
  CGRect frame = CGRectMake(-1.f, 0.f, kTileSize.width + 1, kTileSize.height + 1);
  backgroundView = [[UIImageView alloc] initWithFrame:frame];
  [self addSubview:backgroundView];
}

- (void)addDayLabel
{
  dayLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.width, self.height)];
  dayLabel.textAlignment = UITextAlignmentCenter;
  dayLabel.font = [UIFont boldSystemFontOfSize:24.f];
  dayLabel.backgroundColor = [UIColor clearColor];
  [self addSubview:dayLabel];
}

- (void)reloadStyle
{
  UIImage *markerImage = nil;
  
  self.backgroundColor = [UIColor clearColor];
  
  switch (type) {
      
    case KalTileTypeRegular:
      if (self.selected) {
        dayLabel.textColor = [UIColor whiteColor];
        dayLabel.shadowColor = [UIColor blackColor];
        backgroundView.image = [[UIImage imageNamed:@"kal_tile_selected.png"] stretchableImageWithLeftCapWidth:1 topCapHeight:1];
        markerImage = [UIImage imageNamed:@"kal_marker_selected.png"];
      } else {
        dayLabel.textColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"kal_tile_text_fill.png"]];
        dayLabel.shadowColor = [UIColor whiteColor];
        backgroundView.image = nil;
        markerImage = [UIImage imageNamed:@"kal_marker.png"];
      }
      break;
      
    case KalTileTypeAdjacent:
      dayLabel.textColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"kal_tile_disabled_text_fill.png"]];
      dayLabel.shadowColor = nil;
      backgroundView.image = nil;
      markerImage = [UIImage imageNamed:@"kal_marker_disabled.png"];
      if (self.highlighted) {
        self.backgroundColor = [UIColor lightGrayColor];
      }
      break;
      
    case KalTileTypeToday:
      markerImage = [UIImage imageNamed:@"kal_markertoday.png"];
      dayLabel.textColor = [UIColor whiteColor];
      dayLabel.shadowColor = [UIColor darkGrayColor];
      UIImage *image = self.selected 
                        ? [UIImage imageNamed:@"kal_tiletoday_selected.png"]
                        : [UIImage imageNamed:@"kal_tiletoday.png"];
      backgroundView.image = [image stretchableImageWithLeftCapWidth:6 topCapHeight:0];
      break;
      
    default:
      [NSException raise:@"Cannot find calendar tile style" format:@"unknown error"];
      break;
  }
  
  dayLabel.shadowOffset = self.selected ? CGSizeMake(0.f, -1.f) : CGSizeMake(0.f, 1.f);
  
  if (isMarked) {
    markerView.image = markerImage;
    markerView.hidden = NO;
  } else {
    markerView.hidden = YES;
  }
}

- (void)resetState
{
  [date release];
  date = nil;
  type = KalTileTypeRegular;
  isHighlighted = NO;
  isSelected = NO;
  isMarked = NO;
}

- (void)setDate:(NSDate *)aDate
{
  if (date == aDate)
    return;

  [date release];
  date = [aDate retain];

  [dayLabel setText:[NSString stringWithFormat:@"%lu", (unsigned long)[date cc_day]]];
  [self setNeedsDisplay];
}

- (void)setSelected:(BOOL)selected
{
  if (isSelected == selected)
    return;
  
  isSelected = selected;
  [self setNeedsDisplay];
}

- (void)setHighlighted:(BOOL)highlighted
{
  if (isHighlighted == highlighted)
    return;
  
  isHighlighted = highlighted;
  [self reloadStyle];   // TODO this should be setNeedsDisplay, but for some reason the tile highlight
                        // will not be updated in the UI appropriately UNLESS you directly call reloadStyle.
}

- (void)setType:(KalTileType)tileType
{
  if (type == tileType)
    return;
  
  type = tileType;
  [self setNeedsDisplay];
}

- (void)setMarked:(BOOL)marked
{
  if (isMarked == marked)
    return;
  
  isMarked = marked;
  [self setNeedsDisplay];
}

- (BOOL)isToday { return type == KalTileTypeToday; }

- (BOOL)belongsToAdjacentMonth { return type == KalTileTypeAdjacent; }

- (void)dealloc
{
  [date release];
  [dayLabel release];
  [backgroundView release];
  [markerView release];
  [super dealloc];
}


@end
