Kal - a calendar component for the iPhone
-----------------------------------------

This project aims to provide an open-source implementation of the month view
in Apple's mobile calendar app (MobileCal). When the user taps a day on the calendar,
any associated data for that day will be displayed in a table view directly
below the calendar. As a client of the Kal component, you have 2 responsibilities:

1. Tell Kal which days need to be marked with a dot because they have associated data.
2. Provide UITableViewCells which display the details (if any) for the currently
selected day.

In order to use Kal in your application, you will need to provide an implementation
of the KalDataSource protocol to satisfy these responsibilities. Please see
KalDataSource.h and the included demo app for more details.

Release Notes
-------------

**January 1, 2010**

I have made significant changes to the KalDataSource API so that the client
can respond to the data request asynchronously. The Kal demo app, "Holidays,"
now includes 2 example datasources:

1. HolidayJSONDataSource - retrieves data asynchronously from http://keith.lazuka.org/holidays.json
2. HolidaySqliteDataSource - queries an Sqlite database inside the application bundle and responds synchronously (because the query is fast enough that it doesn't affect UI responsiveness too badly).

**December 19, 2009**

Initial public release on GitHub.

Example Usage
-------------

Note: All of the following example code assumes that it is being called from
within another UIViewController which is in a UINavigationController hierarchy.

How to display a very basic calendar (without any events):

    KalViewController *calendar = [[[KalViewController alloc] init] autorelease];
    [self.navigationController pushViewController:calendar animated:YES];

In most cases you will have some custom data that you want to attach
to the dates on the calendar. The first thing you must do is provide
an implementation of the KalDataSource protocol. Then all you need to do
to display your annotated calendar is instantiate the KalViewController
and tell it to use your KalDataSource implementation (in this case, "MyKalDataSource"):

    id<KalDataSource> source = [[[MyKalDataSource alloc] init] autorelease];
    KalViewController *calendar = [[[KalViewController alloc] initWithDataSource:source] autorelease];
    [self.navigationController pushViewController:calendar animated:YES];

Additional Notes
----------------

The Xcode project includes a simple demo app that demonstrates how to use
the Kal component to display several 2009 and 2010 world holidays.
I have provided both a JSON and an Sqlite example datasource for your convenience.

Kal is fully localized. The month name and days of the week will automatically
use the appropriate language and style for the iPhone's current regional settings.


