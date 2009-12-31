/* 
 * Copyright (c) 2009 Keith Lazuka
 * License: http://www.opensource.org/licenses/mit-license.html
 */

#import "KalViewController.h"
#import "KalLogic.h"
#import "KalDataSource.h"
#import "KalDate.h"
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

- (void)clearTable
{
  [dataSource removeAllItems];
  [tableView reloadData];
}

- (void)fetchMarkedDatesForCurrentMonth
{
  NSDate *from = [[self.calendarView.fromDate NSDate] cc_dateByMovingToBeginningOfDay];
  NSDate *to = [[self.calendarView.toDate NSDate] cc_dateByMovingToEndOfDay];
  [dataSource fetchMarkedDatesFrom:from to:to delegate:self];
}

// -----------------------------------------
#pragma mark KalViewDelegate protocol

- (void)didSelectDate:(KalDate *)date
{
  NSDate *from = [[date NSDate] cc_dateByMovingToBeginningOfDay];
  NSDate *to = [[date NSDate] cc_dateByMovingToEndOfDay];
  [self clearTable];
  [dataSource loadItemsFromDate:from toDate:to delegate:self];
}

- (void)showPreviousMonth
{
  [self clearTable];
  [logic retreatToPreviousMonth];
  [[self calendarView] slideDown];
  [self fetchMarkedDatesForCurrentMonth];
}

- (void)showFollowingMonth
{
  [self clearTable];
  [logic advanceToFollowingMonth];
  [[self calendarView] slideUp];
  [self fetchMarkedDatesForCurrentMonth];
}

// ----------------------------------------
#pragma mark KalDataSourceCallbacks protocol

- (void)finishedFetchingMarkedDates:(NSArray *)markedDates
{
  NSMutableArray *dates = [markedDates mutableCopy];
  for (int i=0; i<[dates count]; i++)
    [dates replaceObjectAtIndex:i withObject:[KalDate dateFromNSDate:[dates objectAtIndex:i]]];
  
  [[self calendarView] markTilesForDates:dates];
}

- (void)finishedLoadingItems
{
  [tableView reloadData];
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
  [self fetchMarkedDatesForCurrentMonth];
}

/*
- (void)showAndSelectToday
{
  if ([[self calendarView] isSliding])
    return;
  
  [logic moveToTodaysMonth];
  [[self calendarView] jumpToSelectedMonth];
  [[self calendarView] selectTodayIfVisible];
  [self fetchMarkedDatesForCurrentMonth];
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
  [self fetchMarkedDatesForCurrentMonth];
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

