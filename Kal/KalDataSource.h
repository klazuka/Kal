/* 
 * Copyright (c) 2009 Keith Lazuka
 * License: http://www.opensource.org/licenses/mit-license.html
 */


/*
 *    KalDataSource protocol
 *    ----------------------
 *
 *  The KalDataSource's protocol has 2 responsibilities:
 *    1) Vend UITableViewCells as part of the UITableViewDataSource protocol.
 *    2) Instruct the KalViewController which days should be marked with a dot.
 *
 *  The protocol is asynchronous to allow implementations to retrieve data
 *  from the network or disk without causing a delay when the user slides
 *  between months.
 *  
 *  When your implementation receives the fetchMarkedDatesFrom:to:delegate:
 *  message, you should load all dates into memory within the provided range
 *  that have content to be shown to the user. Once all of the data is loaded,
 *  you must send the finishedFetchingMarkedDates: message to the 
 *  KalDataSourceCallbacks object in order to complete the asynchronous request.
 *
 *  When your implementation receives the loadItemsFromDate:toDate:delegate:
 *  message, you should load all dates into memory within the provided range
 *  that have content to be shown to the user. Once all of the data is loaded,
 *  add it to your list from which you vend UITableViewCells and send the
 *  finishedLoadingItems message to the KalDataSourceCallbacks object in order to
 *  complete the asynchronous request.
 *
 */

@protocol KalDataSourceCallbacks;

@protocol KalDataSource <NSObject, UITableViewDataSource>
- (void)fetchMarkedDatesFrom:(NSDate *)fromDate to:(NSDate *)toDate delegate:(id<KalDataSourceCallbacks>)delegate;
- (void)loadItemsFromDate:(NSDate *)fromDate toDate:(NSDate *)toDate delegate:(id<KalDataSourceCallbacks>)delegate;
- (void)removeAllItems;
@end

@protocol KalDataSourceCallbacks <NSObject>
- (void)finishedFetchingMarkedDates:(NSArray *)dates;
- (void)finishedLoadingItems;
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