
@interface Holiday : NSObject
{
  NSDate *date;
  NSString *name;
}

@property (nonatomic, retain, readonly) NSDate *date;
@property (nonatomic, retain, readonly) NSString *name;

+ (Holiday*)holidayNamed:(NSString *)name onDate:(NSDate *)date;
- (id)initWithName:(NSString *)name onDate:(NSDate *)date;
- (NSComparisonResult)compare:(Holiday *)otherHoliday;

@end
