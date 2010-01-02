
@interface Holiday : NSObject
{
  NSDate *date;
  NSString *name;
  NSString *country;
}

@property (nonatomic, retain, readonly) NSDate *date;
@property (nonatomic, retain, readonly) NSString *name;
@property (nonatomic, retain, readonly) NSString *country;

+ (Holiday*)holidayNamed:(NSString *)name country:(NSString *)country date:(NSDate *)date;
- (id)initWithName:(NSString *)name country:(NSString *)country date:(NSDate *)date;
- (NSComparisonResult)compare:(Holiday *)otherHoliday;

@end
