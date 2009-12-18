@interface NSDate (KalAdditions)

// All of the following methods use [NSCalendar currentCalendar] to perform
// their calculations.

+ (NSDate *)cc_today;
+ (NSDate *)cc_dateForDay:(NSUInteger)day month:(NSUInteger)month year:(NSUInteger)year; // TODO delete me after I'm done with this convenience method. It should only be needed during the initial build-out of the calendar model.

- (BOOL)cc_isToday;
- (NSDate *)cc_dateByMovingToFirstDayOfTheMonth;
- (NSDate *)cc_dateByMovingToFirstDayOfThePreviousMonth;
- (NSDate *)cc_dateByMovingToFirstDayOfTheFollowingMonth;
- (NSDateComponents *)cc_componentsForMonthDayAndYear;
- (NSUInteger)cc_day;
- (NSUInteger)cc_weekday;
- (NSUInteger)cc_numberOfDaysInMonth;


@end