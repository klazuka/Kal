/* 
 * Copyright (c) 2009 Keith Lazuka
 * License: http://www.opensource.org/licenses/mit-license.html
 */

#import "KalView.h"
#import "KalGridView.h"
#import "KalLogic.h"
#import "KalPrivate.h"

@interface KalView ()
- (void)addSubviewsToHeaderView:(UIView *)headerView;
- (void)addSubviewsToContentView:(UIView *)contentView;
- (void)setHeaderTitleText:(NSString *)text;
@end

//static const CGFloat kHeaderHeight = 44.f;
static const CGFloat kHeaderHeight = 33.f;
static const CGFloat kMonthLabelHeight = 17.f;

@implementation KalView

@synthesize delegate, tableView;

- (id)initWithFrame:(CGRect)frame delegate:(id<KalViewDelegate>)theDelegate logic:(KalLogic *)theLogic
{
  if ((self = [super initWithFrame:frame])) {
    delegate = theDelegate;
    logic = [theLogic retain];
    [logic addObserver:self forKeyPath:@"selectedMonthNameAndYear" options:NSKeyValueObservingOptionNew context:NULL];
    self.autoresizesSubviews = YES;
    self.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    
    UIView *headerView = [[[UIView alloc] initWithFrame:CGRectMake(0.f, 0.f, frame.size.width, kHeaderHeight)] autorelease];
    headerView.backgroundColor = [UIColor grayColor];
    [self addSubviewsToHeaderView:headerView];
    [self addSubview:headerView];
    
    UIView *contentView = [[[UIView alloc] initWithFrame:CGRectMake(0.f, kHeaderHeight, frame.size.width, frame.size.height - kHeaderHeight)] autorelease];
    contentView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    [self addSubviewsToContentView:contentView];
    [self addSubview:contentView];
  }
  
  return self;
}

- (id)initWithFrame:(CGRect)frame
{
  [NSException raise:@"Incomplete initializer" format:@"KalView must be initialized with a delegate and a KalLogic. Use the initWithFrame:delegate:logic: method."];
  return nil;
}

- (void)redrawEntireMonth { [self jumpToSelectedMonth]; }

- (void)slideDown { [gridView slideDown]; }
- (void)slideUp { [gridView slideUp]; }

- (void)showPreviousMonth
{
  if (!gridView.transitioning)
    [delegate showPreviousMonth];
}

- (void)showFollowingMonth
{
  if (!gridView.transitioning)
    [delegate showFollowingMonth];
}

- (void)addSubviewsToHeaderView:(UIView *)headerView
{
  const CGFloat kChangeMonthButtonWidth = 36.0f;
  const CGFloat kChangeMonthButtonHeight = 30.0f;
  const CGFloat kMonthLabelWidth = 200.0f;
  const CGFloat kHeaderVerticalAdjust = 3.f;
  
  // Header background gradient
  UIImageView *backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Kal.bundle/kal_header_background.png"]];
  CGRect imageFrame = headerView.frame;
  imageFrame.origin = CGPointZero;
  backgroundView.frame = imageFrame;
  [headerView addSubview:backgroundView];
  [backgroundView release];
  
  // Create the previous month button on the left side of the view
  CGRect previousMonthButtonFrame = CGRectMake(self.left,
                                               kHeaderVerticalAdjust,
                                               kChangeMonthButtonWidth,
                                               kChangeMonthButtonHeight);
  UIButton *previousMonthButton = [[UIButton alloc] initWithFrame:previousMonthButtonFrame];
  [previousMonthButton setAccessibilityLabel:NSLocalizedString(@"Previous month", nil)];
  [previousMonthButton setImage:[UIImage imageNamed:@"Kal.bundle/kal_left_arrow.png"] forState:UIControlStateNormal];
  previousMonthButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
  previousMonthButton.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
  [previousMonthButton addTarget:self action:@selector(showPreviousMonth) forControlEvents:UIControlEventTouchUpInside];
  [headerView addSubview:previousMonthButton];
  [previousMonthButton release];
  
  // Draw the selected month name centered and at the top of the view
  CGRect monthLabelFrame = CGRectMake((self.width/2.0f) - (kMonthLabelWidth/2.0f),
                                      kHeaderVerticalAdjust+2,
                                      kMonthLabelWidth,
                                      kMonthLabelHeight);
  headerTitleLabel = [[UILabel alloc] initWithFrame:monthLabelFrame];
  headerTitleLabel.backgroundColor = [UIColor clearColor];
  headerTitleLabel.font = [UIFont boldSystemFontOfSize:16.f];
  headerTitleLabel.textAlignment = UITextAlignmentCenter;
//  headerTitleLabel.textColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"Kal.bundle/kal_header_text_fill.png"]];
	headerTitleLabel.textColor = [UIColor whiteColor];
  headerTitleLabel.shadowColor = [UIColor colorWithRed:175.0f/255.0f green:0.0f/255.0f blue:87.0f/255.0f alpha:1.0f];
  headerTitleLabel.shadowOffset = CGSizeMake(0.f, 1.f);
  [self setHeaderTitleText:[logic selectedMonthNameAndYear]];
  [headerView addSubview:headerTitleLabel];
  
  // Create the next month button on the right side of the view
  CGRect nextMonthButtonFrame = CGRectMake(self.width - kChangeMonthButtonWidth,
                                           kHeaderVerticalAdjust,
                                           kChangeMonthButtonWidth,
                                           kChangeMonthButtonHeight);
  UIButton *nextMonthButton = [[UIButton alloc] initWithFrame:nextMonthButtonFrame];
  [nextMonthButton setAccessibilityLabel:NSLocalizedString(@"Next month", nil)];
  [nextMonthButton setImage:[UIImage imageNamed:@"Kal.bundle/kal_right_arrow.png"] forState:UIControlStateNormal];
  nextMonthButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
  nextMonthButton.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
  [nextMonthButton addTarget:self action:@selector(showFollowingMonth) forControlEvents:UIControlEventTouchUpInside];
  [headerView addSubview:nextMonthButton];
  [nextMonthButton release];
  
  // Add column labels for each weekday (adjusting based on the current locale's first weekday)
}

- (void)addSubviewsToContentView:(UIView *)contentView
{
  // Both the tile grid and the list of events will automatically lay themselves
  // out to fit the # of weeks in the currently displayed month.
  // So the only part of the frame that we need to specify is the width.
  CGRect fullWidthAutomaticLayoutFrame = CGRectMake(0.f, 0.f, self.width, 0.f);

  // The tile grid (the calendar body)
  gridView = [[KalGridView alloc] initWithFrame:fullWidthAutomaticLayoutFrame logic:logic delegate:delegate];
  [gridView addObserver:self forKeyPath:@"frame" options:NSKeyValueObservingOptionNew context:NULL];
  [contentView addSubview:gridView];

  // The list of events for the selected day
  tableView = [[UITableView alloc] initWithFrame:fullWidthAutomaticLayoutFrame style:UITableViewStylePlain];
  tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
	tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
  [contentView addSubview:tableView];
  
  // Drop shadow below tile grid and over the list of events for the selected day
//  shadowView = [[UIImageView alloc] initWithFrame:fullWidthAutomaticLayoutFrame];
//  shadowView.image = [UIImage imageNamed:@"Kal.bundle/kal_grid_shadow.png"];
//  shadowView.height = shadowView.image.size.height;
//  [contentView addSubview:shadowView];
  
  // Trigger the initial KVO update to finish the contentView layout
  [gridView sizeToFit];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
  if (object == gridView && [keyPath isEqualToString:@"frame"]) {
    
    /* Animate tableView filling the remaining space after the
     * gridView expanded or contracted to fit the # of weeks
     * for the month that is being displayed.
     *
     * This observer method will be called when gridView's height
     * changes, which we know to occur inside a Core Animation
     * transaction. Hence, when I set the "frame" property on
     * tableView here, I do not need to wrap it in a
     * [UIView beginAnimations:context:].
     */
    CGFloat gridBottom = gridView.top + gridView.height;
    CGRect frame = tableView.frame;
    frame.origin.y = gridBottom;
    frame.size.height = tableView.superview.height - gridBottom;
    tableView.frame = frame;
    shadowView.top = gridBottom;
    
  } else if ([keyPath isEqualToString:@"selectedMonthNameAndYear"]) {
    [self setHeaderTitleText:[change objectForKey:NSKeyValueChangeNewKey]];
    
  } else {
    [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
  }
}

- (void)setHeaderTitleText:(NSString *)text
{
  [headerTitleLabel setText:text];
  [headerTitleLabel sizeToFit];
  headerTitleLabel.left = floorf(self.width/2.f - headerTitleLabel.width/2.f);
}

- (void)jumpToSelectedMonth { [gridView jumpToSelectedMonth]; }

- (void)selectDate:(KalDate *)date { [gridView selectDate:date]; }

- (BOOL)isSliding { return gridView.transitioning; }

- (void)markTilesForDates:(NSArray *)dates { [gridView markTilesForDates:dates]; }

- (KalDate *)selectedDate { return gridView.selectedDate; }

- (void)dealloc
{
  [logic removeObserver:self forKeyPath:@"selectedMonthNameAndYear"];
  [logic release];
  
  [headerTitleLabel release];
  [gridView removeObserver:self forKeyPath:@"frame"];
  [gridView release];
  [tableView release];
  [shadowView release];
  [super dealloc];
}

@end
