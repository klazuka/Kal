/* 
 * Copyright (c) 2009 Keith Lazuka
 * License: http://www.opensource.org/licenses/mit-license.html
 */

#import "KalViewController.h"
#import "KalLogic.h"
#import "KalDataSource.h"
#import "KalPrivate.h"

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

- (KalView*)calendarView { return (KalView*)self.view; }

// -----------------------------------------
#pragma mark KalViewDelegate protocol

- (void)didSelectDate:(NSDate *)date
{
  [dataSource loadDate:date];
  [tableView reloadData];
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
  self.view = [[[KalView alloc] initWithFrame:[[UIScreen mainScreen] applicationFrame] delegate:self logic:logic] autorelease];
  tableView = [[[self calendarView] tableView] retain];
  tableView.dataSource = dataSource;
}

- (void)viewWillAppear:(BOOL)animated
{
  [super viewWillAppear:animated];
  [tableView reloadData];
}

- (void)viewDidAppear:(BOOL)animated
{
  [super viewDidAppear:animated];
  [tableView flashScrollIndicators];
}

#pragma mark -

- (void)dealloc
{
  [logic release];
  [tableView release];
  [dataSource release];
  [super dealloc];
}


@end

