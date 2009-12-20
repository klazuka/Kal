Kal - a calendar component for the iPhone
-----------------------------------------

This project aims to provide an open-source implementation of the month view
in Apple's mobile calendar app. When the user taps a date on the calendar,
any associated event(s) for that date will be displayed in a table view directly
below the calendar. As a client of this component, your only responibility
is to provide the events for each date by providing an implementation
of the KalDataSource protocol.

Example Usage
-------------

Note: All of the following example code assumes that it is being called from
within another UIViewController which is in a UINavigationController hierarchy.

How to display a very basic calendar (without any events):

    KalViewController *calendar = [[[KalViewController alloc] init] autorelease];
    [self.navigationController pushViewController:calendar animated:YES];

In most cases you will have some custom data that you want to attach
to the dates on the calendar. Assuming that your implementation of the
KalDataSource protocol is provided by "MyKalDataSource", then all you
need to do to display your annotated calendar is the following:

    id<KalDataSource> source = [[[MyKalDataSource alloc] init] autorelease];
    KalViewController *calendar = [[[KalViewController alloc] initWithDataSource:source] autorelease];
    [self.navigationController pushViewController:calendar animated:YES];

Note that "MyKalDataSource" will tell the system which days to mark with a 
dot and will provide the UITableViewCells that display the details for
the currently selected date.

Additional Notes
----------------

The Xcode project includes a simple demo app that demonstrates how to use
the Kal component to display the 2009 and 2010 US Holidays.

Kal is fully localized. The month name and days of the week will automatically
use the appropriate language and style for the iPhone's current regional settings.


