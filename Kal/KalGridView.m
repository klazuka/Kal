/* 
 * Copyright (c) 2009 Keith Lazuka
 * License: http://www.opensource.org/licenses/mit-license.html
 */

#import <CoreGraphics/CoreGraphics.h>

#import "KalGridView.h"
#import "KalView.h"
#import "KalMonthView.h"
#import "KalTileView.h"
#import "KalLogic.h"
#import "KalDate.h"
#import "KalPrivate.h"

#define SLIDE_NONE 0
#define SLIDE_UP 1
#define SLIDE_DOWN 2

const CGSize kTileSize = { 46.f, 44.f };

static NSString *kSlideAnimationId = @"KalSwitchMonths";

@interface KalGridView ()
- (void)selectTodayIfVisible;
- (void)swapMonthViews;
@end

@implementation KalGridView

@synthesize selectedTile, highlightedTile, transitioning;

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
    logic = [theLogic retain];
    delegate = theDelegate;
    
    CGRect monthRect = CGRectMake(0.f, 0.f, frame.size.width, frame.size.height);
    frontMonthView = [[KalMonthView alloc] initWithFrame:monthRect];
    backMonthView = [[KalMonthView alloc] initWithFrame:monthRect];
//    frontMonthView.backgroundColor = [UIColor colorWithRed:1.f green:0.0f blue:0.0f alpha:0.3f];
//    backMonthView.backgroundColor = [UIColor colorWithRed:0.f green:0.0f blue:1.f alpha:0.3f];
    backMonthView.hidden = YES;
    [self addSubview:backMonthView];
    [self addSubview:frontMonthView];
    
    [self jumpToSelectedMonth];
    [self selectTodayIfVisible];
  }
  return self;
}

- (void)drawRect:(CGRect)rect
{
  [[UIImage imageNamed:@"kal_grid_background.png"] drawInRect:rect];
  [[UIColor colorWithRed:0.63f green:0.65f blue:0.68f alpha:1.f] setFill];
  CGRect line;
  line.origin = CGPointMake(0.f, self.height - 1.f);
  line.size = CGSizeMake(self.width, 1.f);
  CGContextFillRect(UIGraphicsGetCurrentContext(), line);
}

- (void)sizeToFit
{
  self.height = frontMonthView.height;
}

#pragma mark -
#pragma mark Touches

- (void)setHighlightedTile:(KalTileView *)tile
{
  if (highlightedTile != tile) {
    highlightedTile.highlighted = NO;
    highlightedTile = [tile retain];
    tile.highlighted = YES;
    [tile setNeedsDisplay];
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
      if ([tile.date compare:[KalDate dateFromNSDate:logic.baseDate]] == NSOrderedDescending) {
        [delegate showFollowingMonth];
      } else {
        [delegate showPreviousMonth];
      }
      self.selectedTile = [frontMonthView tileForDate:tile.date];
    } else {
      self.selectedTile = tile;
    }
  }
  self.highlightedTile = nil;
}

- (void)selectTodayIfVisible
{
  KalTileView *todayTile = [frontMonthView todaysTileIfVisible];
  if (todayTile)
    self.selectedTile = todayTile;
}

#pragma mark -
#pragma mark Slide Animation

- (void)swapMonthsAndSlide:(int)direction keepOneRow:(BOOL)keepOneRow
{
  backMonthView.hidden = NO;
  
  // set initial positions before the slide
  if (direction == SLIDE_UP) {
    backMonthView.top = keepOneRow
      ? frontMonthView.bottom - kTileSize.height
      : frontMonthView.bottom;
  } else if (direction == SLIDE_DOWN) {
    NSUInteger numWeeksToKeep = keepOneRow ? 1 : 0;
    NSInteger numWeeksToSlide = [backMonthView numWeeks] - numWeeksToKeep;
    backMonthView.top = -numWeeksToSlide * kTileSize.height;
  } else {
    backMonthView.top = 0.f;
  }
  
  // trigger the slide animation
  [UIView beginAnimations:kSlideAnimationId context:NULL]; {
    [UIView setAnimationsEnabled:direction!=SLIDE_NONE];
    [UIView setAnimationDuration:0.5];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(animationDidStop:finished:context:)];
    
    frontMonthView.top = -backMonthView.top;
    backMonthView.top = 0.f;
    
    self.height = backMonthView.height;
    
    [self swapMonthViews];
  } [UIView commitAnimations];
}

- (void)slide:(int)direction
{
  transitioning = YES;
  
  [backMonthView showDates:logic.daysInSelectedMonth
      leadingAdjacentDates:logic.daysInFinalWeekOfPreviousMonth
     trailingAdjacentDates:logic.daysInFirstWeekOfFollowingMonth];
  
  // At this point, the calendar logic has already been advanced or retreated to the
  // following/previous month, so in order to determine whether there are 
  // any cells to keep, we need to check for a partial week in the month
  // that is sliding offscreen.
  
  BOOL keepOneRow = (direction == SLIDE_UP && [logic.daysInFinalWeekOfPreviousMonth count] > 0)
                    || (direction == SLIDE_DOWN  && [logic.daysInFirstWeekOfFollowingMonth count] > 0);
  
  [self swapMonthsAndSlide:direction keepOneRow:keepOneRow];
  
  self.selectedTile = [frontMonthView firstTileOfMonth];
}

- (void)slideUp { [self slide:SLIDE_UP]; }
- (void)slideDown { [self slide:SLIDE_DOWN]; }

- (void)animationDidStop:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context
{
  transitioning = NO;
  backMonthView.hidden = YES;
}

#pragma mark -

- (void)swapMonthViews
{
  KalMonthView *tmp = backMonthView;
	backMonthView = frontMonthView;
	frontMonthView = tmp;
  [self exchangeSubviewAtIndex:[self.subviews indexOfObject:frontMonthView] withSubviewAtIndex:[self.subviews indexOfObject:backMonthView]];
}

- (void)jumpToSelectedMonth
{
  [self slide:SLIDE_NONE];
}

- (void)markTilesForDates:(NSArray *)dates { [frontMonthView markTilesForDates:dates]; }

- (KalDate *)selectedDate { return selectedTile.date; }

#pragma mark -

- (void)dealloc
{
  [selectedTile release];
  [highlightedTile release];
  [frontMonthView release];
  [backMonthView release];
  [logic release];
  [super dealloc];
}

@end
