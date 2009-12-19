/*
 *    KalDataSource protocol
 *    ----------------------
 *
 *  The KalDataSource's primary responsibility is to vend
 *  data to be displayed in the list of events table view
 *  for the currently selected day in the calendar.
 *
 *  KalDataSource has another responsibility: indicating whether
 *  the calendar should mark a day "tile." Your KalDataSource
 *  implementation should implement the hasDetailsForDate: method such that
 *  it returns YES if the provided date has 1 or more events
 *  associated with it.
 *
 *  KalDataSource's final responsibility is updating the
 *  dataSource's list of table view items whenever the selected
 *  calendar date changes. Your KalDataSource implementation
 *  should implement the loadDate: method such that every time
 *  it is called, it removes all objects from the dataSource's
 *  list of table items, and adds an item for every event associated
 *  with the given date. The type of item that you add to the list should
 *  either be a TTTableItem or your own custom object (provided that
 *  you also implement tableView:cellClassForObject: and
 *  tableView:cell:willAppearAtIndexPath: just like you would any
 *  other custom cell for a Three20 table view).
 */

@protocol KalDataSource <NSObject, UITableViewDataSource>

- (BOOL)hasDetailsForDate:(NSDate *)date;
- (void)loadDate:(NSDate *)date;

@end

#pragma mark -

/*
 *    SimpleKalDataSource
 *    -------------------
 *
 *  An example implementation of the KalDataSource protocol.
 *  It does nothing at all.
 *
 */

@interface SimpleKalDataSource : NSObject <KalDataSource>
{
}
+ (SimpleKalDataSource*)dataSource;
@end