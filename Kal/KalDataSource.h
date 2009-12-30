/* 
 * Copyright (c) 2009 Keith Lazuka
 * License: http://www.opensource.org/licenses/mit-license.html
 */


/*
 *    KalDataSource protocol
 *    ----------------------
 *
 *  The KalDataSource's protocol has 2 responsibilities:
 *    1) vend UITableViewCells as part of the UITableViewDataSource protocol
 *    2) interact with the KalViewController
 *
 */

@protocol KalDataSource <NSObject, UITableViewDataSource>

- (NSArray *)markedDatesFrom:(NSDate *)fromDate to:(NSDate *)toDate;
- (void)loadItemsFromDate:(NSDate *)fromDate toDate:(NSDate *)toDate;

@end

#pragma mark -

/*
 *    SimpleKalDataSource
 *    -------------------
 *
 *  A null implementation of the KalDataSource protocol.
 *
 */

@interface SimpleKalDataSource : NSObject <KalDataSource>
{
}
+ (SimpleKalDataSource*)dataSource;
@end