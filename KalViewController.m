#import "KalViewController.h"
#import "KalLogic.h"
#import "KalDataSource.h"

#define KAL_ROW_HEIGHT 44
CGRect KalNavigationFrame() {
  CGRect frame = [UIScreen mainScreen].applicationFrame;
  return CGRectMake(0, 0, frame.size.width, frame.size.height - KAL_ROW_HEIGHT);
}

@interface KalViewController ()
- (KalView*)calendarView;
@end

@implementation KalViewController

- (id)initWithDataSource:(id<KalDataSource>)source
{
  if ((self = [super init])) {
    dataSource = [source retain];
  }
  return self;
}  

- (id)init
{
  return [self initWithDataSource:[SimpleKalDataSource dataSource]];
}

// -----------------------------------------
#pragma mark KalViewDelegate protocol

- (void)didSelectDate:(NSDate *)date
{
  [dataSource loadDate:date];
}

- (BOOL)shouldMarkTileForDate:(NSDate *)date
{
  return [dataSource hasDetailsForDate:date];
}

- (void)showPreviousMonth
{
  [logic retreatToPreviousMonth];
  [[self calendarView] slideDown];
}

- (void)showFollowingMonth
{
  [logic advanceToFollowingMonth];
  [[self calendarView] slideUp];
}

// -----------------------------------------------------------------------------------
#pragma mark UIViewController

- (void)loadView
{
  self.title = @"Calendar";
  logic = [[KalLogic alloc] init];
  self.view = [[[KalView alloc] initWithFrame:KalNavigationFrame() delegate:self logic:logic] autorelease];
  tableView = [[[self calendarView] tableView] retain];
}

// make the compiler happy
- (KalView*)calendarView { return (KalView*)self.view; }

#pragma mark -

- (void)dealloc
{
  [logic release];
  [tableView release];
  [dataSource release];
  [super dealloc];
}


@end

