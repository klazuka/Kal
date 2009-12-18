#import "KalTileView.h"

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
  frame.origin = CGPointZero;
  frame = UIEdgeInsetsInsetRect(frame, UIEdgeInsetsMake(36, 21, 5, 21));
  markerView = [[UIImageView alloc] initWithFrame:frame];
  [self addSubview:markerView];
}

- (void)addBackground
{
  backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"tile.png"]];
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
  [super setSelected:selected];
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
  
  switch (state & TTCalendarTileStateMode) {
      
    case kTTCalendarTileTypeRegular:
      if (self.selected) {
        dayLabel.textColor = [UIColor whiteColor];
        backgroundView.image = [[UIImage imageNamed:@"tile_selected.png"] stretchableImageWithLeftCapWidth:1 topCapHeight:1];
        markerImage = [UIImage imageNamed:@"marker_selected.png"];
      } else {
        dayLabel.textColor = [UIColor blackColor];
        backgroundView.image = [UIImage imageNamed:@"tile.png"];
        markerImage = [UIImage imageNamed:@"marker.png"];
      }
      break;
      
    case kTTCalendarTileTypeAdjacent:
      dayLabel.textColor = [UIColor grayColor];
      backgroundView.image = [UIImage imageNamed:@"tile.png"];
      markerImage = [UIImage imageNamed:@"marker_disabled.png"];
      if (self.selected) {
        self.backgroundColor = [UIColor darkGrayColor];
      }
      break;
      
    case kTTCalendarTileTypeToday:
      markerImage = [UIImage imageNamed:@"markertoday.png"];
      dayLabel.textColor = [UIColor whiteColor];
      UIImage *image = self.selected 
                         ? [UIImage imageNamed:@"tiletoday_selected.png"]
                         : [UIImage imageNamed:@"tiletoday.png"];
      backgroundView.image = [image stretchableImageWithLeftCapWidth:6 topCapHeight:0];
      break;
      
    default:
      [NSException raise:@"Cannot find calendar tile style" format:@"unknown error"];
      break;
  }
  
  if ([self marked])
    markerView.image = markerImage;

}

- (void)setMode:(NSUInteger)mode
{
  state = (state & ~TTCalendarTileStateMode) | mode;
}

- (void)setDate:(NSDate *)aDate
{
  if (date != aDate) {
    [date release];
    date = [aDate retain];
    
    [dayLabel setText:[NSString stringWithFormat:@"%u", [date cc_day]]];
    
    if ([date cc_isToday]) {
      [self setMode:kTTCalendarTileTypeToday];
      [self reloadStyle];
    }
  }
}

- (BOOL)belongsToAdjacentMonth
{
  return (state & TTCalendarTileStateMode) == kTTCalendarTileTypeAdjacent;
}

- (void)setBelongsToAdjacentMonth:(BOOL)belongsToAdjacentMonth
{
  if (belongsToAdjacentMonth) {
    [self setMode:kTTCalendarTileTypeAdjacent];
  } else {
    if ([date cc_isToday])
      [self setMode:kTTCalendarTileTypeToday];
    else
      [self setMode:kTTCalendarTileTypeRegular];
  }
  
  [self reloadStyle];
}

- (BOOL)marked
{
  return state & TTCalendarTileStateMarked;
}

- (void)setMarked:(BOOL)marked
{
  if ([self marked] == marked)
    return;
  
  if (marked)
    state |= TTCalendarTileStateMarked;
  else
    state &= ~TTCalendarTileStateMarked;
  
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
