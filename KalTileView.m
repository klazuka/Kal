#import "KalTileView.h"

@interface KalTileView ()
- (void)resetState;
- (void)setMode:(NSUInteger)mode;
- (void)reloadStyle;
@end

#pragma mark -

@implementation KalTileView

@synthesize date;

- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
      self.opaque = NO;
      self.backgroundColor = [UIColor orangeColor];
      self.clipsToBounds = NO;
      [self resetState];
      [self reloadStyle];
    }
    return self;
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
      self.width -= 1.f;
      self.left += 1.f;
    } else if (!self.selected && selected) {
      // selection (expand)
      self.width += 1.f;
      self.left -= 1.f;
    }
  }
  
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

- (CGSize)sizeThatFits:(CGSize)size
{
  // Always make the tile square to its width.
  return CGSizeMake(size.width, size.width);
}

#pragma mark Tile State

- (void)prepareForReuse
{
  [self resetState];
  [self reloadStyle];
}

- (void)resetState
{
  // Teset TTCalendarTileState
  state = 0;
  
  // Reset UIControlState
  [self setSelected:NO];
  [self setHighlighted:NO];
  [self setEnabled:YES];
}

- (void)reloadStyle
{
  // TODO display correct PNG for current tile state
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
    return; // nothing to do
  
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
  [super dealloc];
}


@end
