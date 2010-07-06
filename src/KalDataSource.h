/* 
 * Copyright (c) 2009 Keith Lazuka
 * License: http://www.opensource.org/licenses/mit-license.html
 */

#import <UIKit/UIKit.h>

/*
 *    KalDataSource protocol
 *    ----------------------
 *
 *  The KalDataSource's protocol has 2 responsibilities:
 *    1) Vend UITableViewCells as part of the UITableViewDataSource protocol.
 *    2) Instruct the KalViewController which days should be marked with a dot.
 *
 *  The protocol is a mix of asynchronous and synchronous methods.
 *  The primary asynchronous method, presentingDatesFrom:to:delegate:, 
 *  allows implementations to retrieve data from the network or disk
 *  without causing the UI to hang when the user slides between months.
 *
 *  --- Asynchronous part of the protocol ---
 *  
 *    presentingDatesFrom:to:delegate:
 *  
 *        This message will be sent to your dataSource whenever the calendar
 *        switches to a different month. Your code should respond by
 *        loading application data for the specified range of dates and sending the
 *        loadedDataSource: callback message as soon as the appplication data
 *        is ready and available in memory. If the lookup of your application
 *        data is expensive, you should perform the lookup using an asynchronous
 *        API (like NSURLConnection for web service resources) or in a background
 *        thread.
 *
 *        If the application data for the new month is already in-memory,
 *        you must still issue the callback.
 *
 *
 *  --- Synchronous part of the protocol ---
 *
 *    markedDatesFrom:to:
 *
 *        This message will be sent to your dataSource immediately
 *        after you issue the loadedDataSource: callback message
 *        from the body of your presentingDatesFrom:to:delegate method.
 *        You should respond to this message by returning an array of NSDates
 *        for each day in the specified range which has associated application
 *        data.
 *
 *        If this message is received but the application data is not yet
 *        ready, your code should immediately return an empty NSArray.
 *
 *    loadItemsFromDate:toDate:
 *
 *        This message will be sent to your dataSource every time
 *        that the user taps a day on the calendar. You should respond
 *        to this message by updating the list from which you vend
 *        UITableViewCells.
 *
 *        If this message is received but the application data is not yet
 *        ready, your code should do nothing.
 *
 *    removeAllItems
 *
 *        This message will be sent before loadItemsFromDate:toDate
 *        as well as any time that Kal wants to clear the table view
 *        beneath the calendar (for example, when switching between months).
 *        You should respond to this message by removing all objects
 *        from the list from which you vend UITableViewCells.
 *
 */

@protocol KalDataSourceCallbacks;

@protocol KalDataSource <NSObject, UITableViewDataSource>
- (void)presentingDatesFrom:(NSDate *)fromDate to:(NSDate *)toDate delegate:(id<KalDataSourceCallbacks>)delegate;
- (NSArray *)markedDatesFrom:(NSDate *)fromDate to:(NSDate *)toDate;
- (void)loadItemsFromDate:(NSDate *)fromDate toDate:(NSDate *)toDate;
- (void)removeAllItems;
@end

@protocol KalDataSourceCallbacks <NSObject>
- (void)loadedDataSource:(id<KalDataSource>)dataSource;
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
