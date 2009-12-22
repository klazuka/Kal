/* 
 * Copyright (c) 2009 Keith Lazuka
 * License: http://www.opensource.org/licenses/mit-license.html
 */

#import "KalGridView.h"
#import "KalView.h"
#import "KalTileView.h"
#import "KalLogic.h"
#import "KalPrivate.h"

#define SLIDE_NONE 0
#define SLIDE_UP 1
#define SLIDE_DOWN 2

static NSString *kSlideAnimationId = @"KLSlideAnimationId";
static const NSUInteger kTilePoolSize = 6*3; // 6weeks * 3months (always have two spare month's worth of tiles available)
static const CGSize kTileSize = { 46.f, 44.f };

@interface KalGridView ()
- (void)initializeCell:(UIView *)cell;
- (NSArray *)dequeueAndConfigureNextBatchOfCellsForSlide:(int)direction;
- (void)selectTodayIfVisible;
@end

@implementation KalGridView

@synthesize selectedTile, highlightedTile;

- (id)initWithFrame:(CGRect)frame logic:(KalLogic *)theLogic delegate:(id<KalViewDelegate>)theDelegate
{
  // MobileCal uses 46px wide tiles, with a 2px inner stroke 
  // along the top and right edges. Since there are 7 columns,
  // the width needs to be 46*7 (322px). But the iPhone's screen
  // is only 320px wide, so we need to make the
  // frame extend just beyond the right edge of the screen
  // to accomodate all 7 columns. The 7th day's 2px inner stroke
  // will be clipped off the screen, but that's fine because
  // MobileCal does the same thing.
  frame.size.width = 7 * kTileSize.width;
  
  if (self = [super initWithFrame:frame]) {
    self.clipsToBounds = YES;
    reusableCells = [[NSMutableArray alloc] init];
    cellHeight = kTileSize.height;
    logic = [theLogic retain];
    delegate = theDelegate;
    
    // Allocate the pool of cells. Each cell represents a calendar week (a single row of 7 KalTileViews).
    for (NSUInteger i = 0; i < kTilePoolSize; i++) {
      UIView *cell = [[[UIView alloc] initWithFrame:CGRectMake(0.f, 0.f, self.width, cellHeight)] autorelease];
      [self initializeCell:cell];
      [reusableCells enqueue:cell];
    }
    
    for (UIView *cell in [self dequeueAndConfigureNextBatchOfCellsForSlide:SLIDE_NONE])
      [self addSubview:cell];
    
    [self selectTodayIfVisible];
    
    [self sizeToFit];
  }
  return self;
}

- (void)drawRect:(CGRect)rect
{
  [[UIImage imageNamed:@"kal_grid_background.png"] drawInRect:rect];
}

- (void)receivedTouches:(NSSet *)touches withEvent:event
{
  UITouch *touch = [touches anyObject];
  CGPoint location = [touch locationInView:self];
  UIView *hitView = [self hitTest:location withEvent:event];
  
  if (!hitView)
    return;
  
  if ([hitView isKindOfClass:[KalTileView class]]) {
    KalTileView *tile = (KalTileView*)hitView;
    if (tile.belongsToAdjacentMonth) {
      self.highlightedTile = tile;
    } else {
      self.highlightedTile = nil;
      self.selectedTile = tile;
    }
  }
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
  [self receivedTouches:touches withEvent:event];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
  [self receivedTouches:touches withEvent:event];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
  UITouch *touch = [touches anyObject];
  CGPoint location = [touch locationInView:self];
  UIView *hitView = [self hitTest:location withEvent:event];
  
  if ([hitView isKindOfClass:[KalTileView class]]) {
    KalTileView *tile = (KalTileView*)hitView;
    if (tile.belongsToAdjacentMonth) {
      if ([tile.date timeIntervalSinceDate:logic.baseDate] > 0) {
        [delegate showFollowingMonth];
      } else {
        [delegate showPreviousMonth];
      }
    }
    self.selectedTile = tile;
  }
  self.highlightedTile = nil;
}

- (void)updateTilesInKeptCell:(UIView*)cell
{
  // Days that were part of the adjacent month before
  // are now part of the selected month, and vice versa.
  // So we need to toggle the flags and ensure that a
  // tile that is part of the adjacent month cannot
  // be currently selected.
  for (KalTileView *tile in cell.subviews)
    tile.belongsToAdjacentMonth = !tile.belongsToAdjacentMonth;
  
  if (self.selectedTile.belongsToAdjacentMonth)
    self.selectedTile = nil;
}

- (void)sizeToFit
{
  // Resize |self| such that it is just tall enough to fit all of its subviews.
  self.height = [[self.subviews valueForKeyPath:@"@sum.height"] floatValue];
}

- (void)setHighlightedTile:(KalTileView *)tile
{
  if (highlightedTile != tile) {
    highlightedTile.highlighted = NO;
    highlightedTile = [tile retain];
    tile.highlighted = YES;
  }
}

- (void)setSelectedTile:(KalTileView *)tile
{
  if (selectedTile != tile) {
    selectedTile.selected = NO;
    selectedTile = [tile retain];
    tile.selected = YES;
    [delegate didSelectDate:tile.date];
  }
}

- (void)selectTodayIfVisible
{
  for (UIView *cell in self.subviews) {
    for (KalTileView *tile in cell.subviews) {
      if ([tile.date cc_isToday] && !tile.belongsToAdjacentMonth) {
        self.selectedTile = tile;
        return;
      }
    }
  }
}

- (NSArray *)dequeueAndConfigureNextBatchOfCellsForSlide:(int)direction
{
  NSMutableArray *nextBatchOfCells = [NSMutableArray array];
  
  // Layout and configure the visible tiles/weeks for the currently selected month.
  NSArray *previousPartials = [logic daysInFinalWeekOfPreviousMonth];
  NSArray *regularDays = [logic daysInSelectedMonth];
  NSArray *followingPartials = [logic daysInFirstWeekOfFollowingMonth];
  
  NSMutableArray *allVisibleDays = [NSMutableArray array];
  [allVisibleDays addObjectsFromArray:previousPartials];
  [allVisibleDays addObjectsFromArray:regularDays];
  [allVisibleDays addObjectsFromArray:followingPartials];
  
  if (direction == SLIDE_UP && [previousPartials count] > 0) {
    // Remove the first 7 days since they are part of
    // a cell that is already being displayed (the "kept" cell).
    [allVisibleDays removeObjectsInRange:NSMakeRange(0, 7)];
    
  } else if (direction == SLIDE_DOWN && [followingPartials count] > 0) {
    // Remove the last 7 days since they are part of a 
    // cell that is already being displayed (the "kept" cell).
    NSUInteger loc = [allVisibleDays count] - 7;
    [allVisibleDays removeObjectsInRange:NSMakeRange(loc, 7)];    
  }
  
  CGFloat verticalOffset = 0.f;
  BOOL done = NO;
  while (!done) {
    UIView *cell = [reusableCells dequeue];
    cell.top = verticalOffset;
    verticalOffset += cellHeight;
    for (KalTileView *tile in cell.subviews) {
      [tile prepareForReuse];
      NSDate *date = [allVisibleDays objectAtIndex:0];
      tile.date = date;
      tile.belongsToAdjacentMonth = [previousPartials indexOfObject:date] != NSNotFound || [followingPartials indexOfObject:date] != NSNotFound;
      tile.marked = [delegate shouldMarkTileForDate:date];
      if ([date isEqualToDate:logic.baseDate])
        self.selectedTile = tile;
      [allVisibleDays removeObjectAtIndex:0];
    }
    [nextBatchOfCells addObject:cell];
    done = [allVisibleDays count] == 0;
  }
  
  return nextBatchOfCells;
}

- (void)initializeCell:(UIView *)cell
{
  const CGRect kTileFrame = { CGPointZero, kTileSize };
  
  for (NSUInteger i = 0; i < 7; i++) {
    KalTileView *tile = [[KalTileView alloc] initWithFrame:kTileFrame];
    tile.left = i * kTileSize.width; // horizontal layout
    tile.date = [NSDate distantPast];
    [cell addSubview:tile];
    [tile release];
  }
}

#pragma mark -
#pragma mark Slide Animation

- (void)slide:(int)direction cells:(NSArray *)nextBatchOfCells keepOneRow:(BOOL)keepOneRow
{
  // Get a reference to the single cell to be kept (or none if not requested by the client)
  UIView *keptCell = nil;
  if (keepOneRow) {
    CGFloat searchPattern = direction == SLIDE_UP ? self.height - cellHeight : 0.f;
    for (UIView *cell in self.subviews) {
      if (cell.top == searchPattern) {
        keptCell = cell;
        break;
      }
    }
    [self updateTilesInKeptCell:keptCell];
    if (direction == SLIDE_UP) {
      BOOL alreadyHasSelection = NO;
      for (KalTileView *tile in keptCell.subviews) {
        if (tile.selected) {
          alreadyHasSelection = YES;
          break;
        }
      }
      if (!alreadyHasSelection) {
        for (KalTileView *tile in keptCell.subviews) {
          if ([tile.date isEqualToDate:logic.baseDate]) {
            self.selectedTile = tile;
            break;
          }
        }
      }
    }
    NSAssert(keptCell, @"The client requested that we keep one row, but I couldn't find the correct row to keep!");
  }
  
  // Take the fresh cells and apply a simple vertical layout
  // such that the entire batch is immediately above or below 
  // the last cell that is currently being shown.
  // The decision whether to place it above or below
  // is based on the direction that we are sliding.
  // Finally, add it as a subview.
  CGFloat verticalOffset = 0.f;
  for (UIView *cell in nextBatchOfCells) {
    cell.top = direction == SLIDE_UP 
    ? self.height + verticalOffset
    : -1 * ([nextBatchOfCells count] * cellHeight - verticalOffset);
    [self addSubview:cell];
    verticalOffset += cellHeight;
  }
  
  // Slide each cell with animation.
  [UIView beginAnimations:kSlideAnimationId context:NULL];
  {
    [UIView setAnimationsEnabled:direction != SLIDE_NONE];
    [UIView setAnimationDuration:0.45f];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(animationDidStop:finished:context:)];
    
    CGFloat dy = direction == SLIDE_UP
                    ? -1 * (self.height - (keepOneRow ? cellHeight : 0.f))
                    : [nextBatchOfCells count] * cellHeight;
    
    for (UIView *cell in self.subviews)
      cell.top += dy;
    
    // Resize |self| such that it is just tall enough to fit
    // the kept row (if any) and the new rows that we are adding.
    self.height = keptCell.height + [[nextBatchOfCells valueForKeyPath:@"@sum.height"] floatValue];
  }
  [UIView commitAnimations];
}

- (void)slide:(int)direction
{
  // At this point, the calendar logic has already been advanced or retreated to the
  // following/previous month, so in order to determine whether there are 
  // any cells to keep, we need to check for a partial week in the month
  // that is sliding offscreen.
  NSArray *cells = [self dequeueAndConfigureNextBatchOfCellsForSlide:direction];
  BOOL keepOneRow = NO;

  if (direction == SLIDE_UP && [[logic daysInFinalWeekOfPreviousMonth] count] > 0) {
    keepOneRow = YES;
  } else if (direction == SLIDE_DOWN  && [[logic daysInFirstWeekOfFollowingMonth] count] > 0) {
    keepOneRow = YES;
  }
  
  [self slide:direction cells:cells keepOneRow:keepOneRow];
}

- (void)slideUp { [self slide:SLIDE_UP]; }
- (void)slideDown { [self slide:SLIDE_DOWN]; }

- (void)animationDidStop:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context
{
  // Reuse every cell that is no longer visible after the slide animation.
  for (UIView *cell in self.subviews) {
    if (cell.bottom <= 0 || cell.bottom > self.height) {
      [[cell retain] autorelease];
      [cell removeFromSuperview];
      [reusableCells enqueue:cell];
    }
  }
}

#pragma mark -
- (void)jumpToSelectedMonth
{
  [self slide:SLIDE_NONE];
}

#pragma mark -

- (void)dealloc
{
  [selectedTile release];
  [highlightedTile release];
  [reusableCells release];
  [logic release];
  [super dealloc];
}


@end
