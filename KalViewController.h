#import "KalView.h" // for the KalViewDelegate protocol

@class KalLogic;

@protocol KalDataSource;

/*
 *    KalViewController
 *    ------------------------
 *
 *  As a client of Three20's calendar system, this is your main entry-point
 *  into using the calendar in your app. The Kal system aims to mimic
 *  Apple's mobile calendar app as much as possible. When the user taps a date,
 *  any associated events for that date are displayed in a table view directly
 *  below the calendar. Your only responibility is to provide the events
 *  for each date via KalDataSource.
 *
 *  KalViewController automatically creates both the calendar view
 *  and the events table view for you. The only thing you need to provide
 *  is a KalDataSource so that the calendar system knows which days to
 *  mark with a dot and which events to list under the calendar when a certain
 *  date is selected (just like in Apple's calendar app).
 *
 *  EXAMPLES
 *  --------
 *  Note: All of the following example code assumes that it is being called from
 *  within another UIViewController which is in a UINavigationController hierarchy.
 *
 *  Here is how you would display a very basic calendar (without any events):
 *
 *    KalViewController *calendar = [[[KalViewController alloc] init] autorelease];
 *    [self.navigationController pushViewController:calendar animated:YES];
 *
 *  In most cases you will have some custom data that you want to attach
 *  to the dates on the calendar. In this case, all you need to do to display
 *  your annotated calendar is the following:
 *
 *    id<KalDataSource> source = [[[MyKalDataSource alloc] init] autorelease];
 *    KalViewController *calendar = [[[KalViewController alloc] initWithDataSource:source] autorelease];
 *    [self.navigationController pushViewController:calendar animated:YES];
 *
 */
@interface KalViewController : UIViewController <KalViewDelegate>
{
  KalLogic *logic;
  UITableView *tableView;
  id <KalDataSource> dataSource;
}

- (id)initWithDataSource:(id<KalDataSource>)source; // designated initializer

@end
