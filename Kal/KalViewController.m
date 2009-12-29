/* 
 * Copyright (c) 2009 Keith Lazuka
 * License: http://www.opensource.org/licenses/mit-license.html
 */

#import "KalViewController.h"
#import "KalLogic.h"
#import "KalDataSource.h"
#import "KalPrivate.h"

#define PROFILER 1
#if PROFILER
#include <mach/mach_time.h>
#include <time.h>
#include <math.h>
void mach_absolute_difference(uint64_t end, uint64_t start, struct timespec *tp)
{
    uint64_t difference = end - start;
    static mach_timebase_info_data_t info = {0,0};

    if (info.denom == 0)
        mach_timebase_info(&info);
    
    uint64_t elapsednano = difference * (info.numer / info.denom);
    tp->tv_sec = elapsednano * 1e-9;
    tp->tv_nsec = elapsednano - (tp->tv_sec * 1e9);
}
#endif

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

// ---------------------------------------
#pragma mark -

- (void)showAndSelectToday
{
  if ([[self calendarView] isSliding])
    return;
  
  [logic moveToTodaysMonth];
  
#if PROFILER
  uint64_t start, end;
  struct timespec tp;
  start = mach_absolute_time();
#endif
  
  [[self calendarView] jumpToSelectedMonth];
  
#if PROFILER
  end = mach_absolute_time();
  mach_absolute_difference(end, start, &tp);
  printf("[[self calendarView] jumpToSelectedMonth]: %.1f ms\n", tp.tv_nsec / 1e6);
#endif
  
  [[self calendarView] selectTodayIfVisible];
}

/*
- (void)showAndSelectToday
{
  if ([[self calendarView] isSliding])
    return;
  
  [logic moveToTodaysMonth];
  [[self calendarView] jumpToSelectedMonth];
  [[self calendarView] selectTodayIfVisible];
}
 */

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

