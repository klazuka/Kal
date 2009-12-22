/* 
 * Copyright (c) 2009 Keith Lazuka
 * License: http://www.opensource.org/licenses/mit-license.html
 */

#import "KalTileView.h"
#import "KalPrivate.h"

@interface KalTileView ()
- (void)resetState;
- (void)setMode:(NSUInteger)mode;
- (void)reloadStyle;
- (void)addBackground;
- (void)addDayLabel;
- (void)addMarkerView;
@end

#pragma mark -

@implementation KalTileView

@synthesize date, dayLabel, backgroundView;

- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
      self.opaque = NO;
      self.backgroundColor = [UIColor clearColor];
      self.clipsToBounds = NO;
      [self resetState];
      [self addBackground];
      [self addDayLabel];
      [self addMarkerView];
      [self reloadStyle];
    }
    return self;
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
  backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"kal_tile.png"]];
  CGRect imageFrame = self.frame;
  imageFrame.origin = CGPointZero;
  backgroundView.frame = imageFrame;
  [self addSubview:backgroundView];
}

- (void)addDayLabel
{
  dayLabel = [[UILabel alloc] initWithFrame:self.frame];
  dayLabel.textAlignment = UITextAlignmentCenter;
  dayLabel.font = [UIFont boldSystemFontOfSize:24.f];
  dayLabel.backgroundColor = [UIColor clearColor];
  [self addSubview:dayLabel];
}

#pragma mark UIControl

- (UIControlState)state
{
  return [super state] | state;
}

- (void)setSelected:(BOOL)selected
{
  // In order to draw the selection border the same way that
  // Apple does in MobileCal, we need to extend the tile 1px
  // to the left so that it draws its left border on top of
  // the left-adjacent tile's right border.
  // (but even this hack does not perfectly mimic the way
  // that Apple draws the bottom border of a selected tile).
  if (!self.belongsToAdjacentMonth) {
      if (self.selected && !selected) {
        // deselection (shrink)
        backgroundView.width -= 1.f;
         backgroundView.left += 1.f;
       } else if (!self.selected && selected) {
        // selection (expand)
        backgroundView.width += 1.f;
        backgroundView.left -= 1.f;
       }
  }
  
  [super setSelected:selected];
  [self reloadStyle];
}

- (void)setHighlighted:(BOOL)highlighted
{
  [super setHighlighted:highlighted];
  [self reloadStyle];
}

#pragma mark UIView and UIResponder

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event { [[self nextResponder] touchesBegan:touches withEvent:event]; }
- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event { [[self nextResponder] touchesMoved:touches withEvent:event]; }
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event { [[self nextResponder] touchesEnded:touches withEvent:event]; }
- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event { [[self nextResponder] touchesCancelled:touches withEvent:event]; }

- (UIResponder *)nextResponder
{
  // It appears that UIControl is swallowing up touch events
  // that try to bubble up the responder chain. So I hook 
  // everything up here again.
  return [self superview];
}

#pragma mark Tile State

- (void)prepareForReuse
{
  [self resetState];
  [self reloadStyle];
}

- (void)resetState
{
  state = 0;
  [self setSelected:NO];
  [self setHighlighted:NO];
  [self setEnabled:YES];
}

- (void)reloadStyle
{
  UIImage *markerImage = nil;
  
  self.backgroundColor = [UIColor clearColor];
  
  switch (state & KalTileStateMode) {
      
    case kKalTileTypeRegular:
      if (self.selected) {
        dayLabel.textColor = [UIColor whiteColor];
        dayLabel.shadowColor = [UIColor blackColor];
        backgroundView.image = [[UIImage imageNamed:@"kal_tile_selected.png"] stretchableImageWithLeftCapWidth:1 topCapHeight:1];
        markerImage = [UIImage imageNamed:@"kal_marker_selected.png"];
      } else {
        dayLabel.textColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"kal_tile_text_fill.png"]];
        dayLabel.shadowColor = [UIColor whiteColor];
        backgroundView.image = [UIImage imageNamed:@"kal_tile.png"];
        markerImage = [UIImage imageNamed:@"kal_marker.png"];
      }
      break;
      
    case kKalTileTypeAdjacent:
      dayLabel.textColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"kal_tile_disabled_text_fill.png"]];
      dayLabel.shadowColor = nil;
      backgroundView.image = [UIImage imageNamed:@"kal_tile.png"];
      markerImage = [UIImage imageNamed:@"kal_marker_disabled.png"];
      if (self.highlighted) {
        self.backgroundColor = [UIColor lightGrayColor];
      }
      break;
      
    case kKalTileTypeToday:
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
  
  if ([self marked]) {
    markerView.image = markerImage;
    markerView.hidden = NO;
  } else {
    markerView.hidden = YES;
  }
}

- (void)setMode:(NSUInteger)mode
{
  state = (state & ~KalTileStateMode) | mode;
}

- (void)setDate:(NSDate *)aDate
{
  if (date != aDate) {
    [date release];
    date = [aDate retain];
    
    [dayLabel setText:[NSString stringWithFormat:@"%u", [date cc_day]]];
    
    if ([date cc_isToday]) {
      [self setMode:kKalTileTypeToday];
      [self reloadStyle];
    }
  }
}

- (BOOL)belongsToAdjacentMonth
{
  return (state & KalTileStateMode) == kKalTileTypeAdjacent;
}

- (void)setBelongsToAdjacentMonth:(BOOL)belongsToAdjacentMonth
{
  if (belongsToAdjacentMonth) {
    [self setMode:kKalTileTypeAdjacent];
  } else {
    if ([date cc_isToday])
      [self setMode:kKalTileTypeToday];
    else
      [self setMode:kKalTileTypeRegular];
  }
  
  [self reloadStyle];
}

- (BOOL)marked
{
  return (state & KalTileStateMarked) == kKalTileMarked;
}

- (void)setMarked:(BOOL)marked
{
  if ([self marked] == marked)
    return;
  
  if (marked)
    state |= KalTileStateMarked;
  else
    state &= ~KalTileStateMarked;
  
  [self reloadStyle];
}

#pragma mark -

- (void)dealloc
{
  [date release];
  [dayLabel release];
  [backgroundView release];
  [markerView release];
  [super dealloc];
}


@end
