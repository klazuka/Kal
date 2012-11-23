/* 
 * Copyright (c) 2009 Keith Lazuka
 * License: http://www.opensource.org/licenses/mit-license.html
 */

#import "KalTileView.h"
#import "KalDate.h"
#import "KalPrivate.h"

extern const CGSize kTileSize;

// UIAppearanceContainer

static struct {
  NSString *backgroundImage;
  NSString *textColor;
  NSString *shadowColor;
  NSString *markerImage;
  NSString *reversesShadow;
} kAppearanceAttributes = {
  .backgroundImage = @"backgroundImage",
  .textColor = @"textColor",
  .shadowColor = @"shadowColor",
  .markerImage = @"markerImage",
  .reversesShadow = @"reversesShadow",
};
static NSMutableDictionary *defaultAppearance = nil;


// KalTileView

@interface KalTileView()
+ (void)setAppearance:(NSMutableDictionary *)appearance value:(id)value forKey:(NSString *)key state:(KalTileState)state;
+ (BOOL)appearance:(NSDictionary *)appearance hasValue:(id *)outValue forKey:(NSString *)key state:(KalTileState)state;
- (id)attributeForKey:(NSString *)key state:(KalTileState)state;
@end

@implementation KalTileView

@synthesize date;
@synthesize shadowOffset;

+ (void)initialize
{
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    
    defaultAppearance = [[NSMutableDictionary alloc] init];
    
    [self setAppearance:defaultAppearance
                  value:[[UIImage imageNamed:@"Kal.bundle/kal_tile_today.png"] stretchableImageWithLeftCapWidth:6 topCapHeight:0]
                 forKey:kAppearanceAttributes.backgroundImage
                  state:KalTileStateToday];
    
    [self setAppearance:defaultAppearance
                  value:[[UIImage imageNamed:@"Kal.bundle/kal_tile_today_selected.png"] stretchableImageWithLeftCapWidth:6 topCapHeight:0]
                 forKey:kAppearanceAttributes.backgroundImage
                  state:KalTileStateToday | KalTileStateSelected];
    
    [self setAppearance:defaultAppearance
                  value:[[UIImage imageNamed:@"Kal.bundle/kal_tile_selected.png"] stretchableImageWithLeftCapWidth:1 topCapHeight:0]
                 forKey:kAppearanceAttributes.backgroundImage
                  state:KalTileStateSelected];
    
    [self setAppearance:defaultAppearance
                  value:[UIColor colorWithPatternImage:[UIImage imageNamed:@"Kal.bundle/kal_tile_text_fill.png"]]
                 forKey:kAppearanceAttributes.textColor
                  state:KalTileStateNormal];
    
    [self setAppearance:defaultAppearance
                  value:[UIColor whiteColor]
                 forKey:kAppearanceAttributes.textColor
                  state:KalTileStateToday];
    
    [self setAppearance:defaultAppearance
                  value:[UIColor whiteColor]
                 forKey:kAppearanceAttributes.textColor
                  state:KalTileStateSelected];
    
    [self setAppearance:defaultAppearance
                  value:[UIColor colorWithPatternImage:[UIImage imageNamed:@"Kal.bundle/kal_tile_dim_text_fill.png"]]
                 forKey:kAppearanceAttributes.textColor
                  state:KalTileStateAdjacent];
    
    [self setAppearance:defaultAppearance
                  value:[UIColor whiteColor]
                 forKey:kAppearanceAttributes.shadowColor
                  state:KalTileStateNormal];
    
    [self setAppearance:defaultAppearance
                  value:[UIColor blackColor]
                 forKey:kAppearanceAttributes.shadowColor
                  state:KalTileStateToday];
    
    [self setAppearance:defaultAppearance
                  value:[UIColor blackColor]
                 forKey:kAppearanceAttributes.shadowColor
                  state:KalTileStateSelected];
    
    [self setAppearance:defaultAppearance
                  value:nil
                 forKey:kAppearanceAttributes.shadowColor
                  state:KalTileStateAdjacent];
    
    [self setAppearance:defaultAppearance
                  value:[UIImage imageNamed:@"Kal.bundle/kal_marker.png"]
                 forKey:kAppearanceAttributes.markerImage
                  state:KalTileStateNormal];
    
    [self setAppearance:defaultAppearance
                  value:[UIImage imageNamed:@"Kal.bundle/kal_marker_today.png"]
                 forKey:kAppearanceAttributes.markerImage
                  state:KalTileStateToday];
    
    [self setAppearance:defaultAppearance
                  value:[UIImage imageNamed:@"Kal.bundle/kal_marker_selected.png"]
                 forKey:kAppearanceAttributes.markerImage
                  state:KalTileStateSelected];
    
    [self setAppearance:defaultAppearance
                  value:[UIImage imageNamed:@"Kal.bundle/kal_marker_dim.png"]
                 forKey:kAppearanceAttributes.markerImage
                  state:KalTileStateAdjacent];
  });
}

- (id)initWithFrame:(CGRect)frame
{
  if ((self = [super initWithFrame:frame])) {
    self.opaque = NO;
    self.backgroundColor = [UIColor clearColor];
    self.clipsToBounds = NO;
    origin = frame.origin;
    [self setIsAccessibilityElement:YES];
    [self setAccessibilityTraits:UIAccessibilityTraitButton];
    appearance = [[NSMutableDictionary alloc] init];
    [self resetState];
  }
  return self;
}

- (void)drawRect:(CGRect)rect
{
  CGContextRef ctx = UIGraphicsGetCurrentContext();
  CGFloat fontSize = 24.f;
  UIFont *font = [UIFont boldSystemFontOfSize:fontSize];
  CGContextSelectFont(ctx, [font.fontName cStringUsingEncoding:NSUTF8StringEncoding], fontSize, kCGEncodingMacRoman);
      
  CGContextTranslateCTM(ctx, 0, kTileSize.height);
  CGContextScaleCTM(ctx, 1, -1);
  
  int state = self.state;
  UIColor *textColor = [self textColorForState:state];
  UIColor *shadowColor = [self shadowColorForState:state];
  UIImage *markerImage = [self markerImageForState:state];
  UIImage *backgroundImage = [self backgroundImageForState:state];
  
  [backgroundImage drawInRect:CGRectMake(0, -1, kTileSize.width+1, kTileSize.height+1)];
  
  if (flags.marked)
    [markerImage drawInRect:CGRectMake(21.f, 5.f, 4.f, 5.f)];
  
  NSUInteger n = [self.date day];
  NSString *dayText = [NSString stringWithFormat:@"%lu", (unsigned long)n];
  const char *day = [dayText cStringUsingEncoding:NSUTF8StringEncoding];
  CGSize textSize = [dayText sizeWithFont:font];
  CGFloat textX, textY;
  textX = roundf(0.5f * (kTileSize.width - textSize.width));
  textY = 6.f + roundf(0.5f * (kTileSize.height - textSize.height));
  if (shadowColor) {
    [shadowColor setFill];
    int sign = [self reversesShadowForState:state] ? -1 : 1;
    CGContextShowTextAtPoint(ctx, textX + shadowOffset.width, textY - sign * shadowOffset.height, day, n >= 10 ? 2 : 1);
  }
  [textColor setFill];
  CGContextShowTextAtPoint(ctx, textX, textY, day, n >= 10 ? 2 : 1);
  
  if (self.highlighted) {
    [[UIColor colorWithWhite:0.25f alpha:0.3f] setFill];
    CGContextFillRect(ctx, CGRectMake(0.f, 0.f, kTileSize.width, kTileSize.height));
  }
}

- (void)resetState
{
  // realign to the grid
  CGRect frame = self.frame;
  frame.origin = origin;
  frame.size = kTileSize;
  self.frame = frame;
  
  [date release];
  date = nil;
  flags.type = KalTileTypeRegular;
  flags.highlighted = NO;
  flags.selected = NO;
  flags.marked = NO;
  shadowOffset = CGSizeMake(0, 1);
}

- (void)setDate:(KalDate *)aDate
{
  if (date == aDate)
    return;

  [date release];
  date = [aDate retain];

  [self setNeedsDisplay];
}

- (BOOL)isSelected { return flags.selected; }

- (void)setSelected:(BOOL)selected
{
  if (flags.selected == selected)
    return;

  // workaround since I cannot draw outside of the frame in drawRect:
  if (![self isToday]) {
    CGRect rect = self.frame;
    if (selected) {
      rect.origin.x--;
      rect.size.width++;
      rect.size.height++;
    } else {
      rect.origin.x++;
      rect.size.width--;
      rect.size.height--;
    }
    self.frame = rect;
  }
  
  flags.selected = selected;
  [self setNeedsDisplay];
}

- (BOOL)isHighlighted { return flags.highlighted; }

- (void)setHighlighted:(BOOL)highlighted
{
  if (flags.highlighted == highlighted)
    return;
  
  flags.highlighted = highlighted;
  [self setNeedsDisplay];
}

- (BOOL)isMarked { return flags.marked; }

- (void)setMarked:(BOOL)marked
{
  if (flags.marked == marked)
    return;
  
  flags.marked = marked;
  [self setNeedsDisplay];
}

- (KalTileType)type { return flags.type; }

- (void)setType:(KalTileType)tileType
{
  if (flags.type == tileType)
    return;
  
  // workaround since I cannot draw outside of the frame in drawRect:
  CGRect rect = self.frame;
  if (tileType == KalTileTypeToday) {
    rect.origin.x--;
    rect.size.width++;
    rect.size.height++;
  } else if (flags.type == KalTileTypeToday) {
    rect.origin.x++;
    rect.size.width--;
    rect.size.height--;
  }
  self.frame = rect;
  
  flags.type = tileType;
  [self setNeedsDisplay];
}

- (KalTileState)state { return *(int *)(&flags); }


- (BOOL)isToday { return flags.type == KalTileTypeToday; }

- (BOOL)belongsToAdjacentMonth { return flags.type == KalTileTypeAdjacent; }


#pragma mark -
#pragma mark Appearance

- (void)setBackgroundImage:(UIImage *)image forState:(KalTileState)state
{
  [KalTileView setAppearance:appearance value:image forKey:kAppearanceAttributes.backgroundImage state:state];
  [self setNeedsDisplay];
}

- (void)setMarkerImage:(UIImage *)image forState:(KalTileState)state
{
  [KalTileView setAppearance:appearance value:image forKey:kAppearanceAttributes.markerImage state:state];
  [self setNeedsDisplay];
}

- (void)setTextColor:(UIColor *)color forState:(KalTileState)state
{
  [KalTileView setAppearance:appearance value:color forKey:kAppearanceAttributes.textColor state:state];
  [self setNeedsDisplay];
}

- (void)setShadowColor:(UIColor *)color forState:(KalTileState)state
{
  [KalTileView setAppearance:appearance value:color forKey:kAppearanceAttributes.shadowColor state:state];
  [self setNeedsDisplay];
}

- (void)setReversesShadow:(NSInteger)flag forState:(KalTileState)state
{
  [KalTileView setAppearance:appearance value:[NSNumber numberWithBool:flag] forKey:kAppearanceAttributes.reversesShadow state:state];
  [self setNeedsDisplay];
}

- (UIImage *)markerImageForState:(KalTileState)state
{
  return [self attributeForKey:kAppearanceAttributes.markerImage state:state];
}

- (UIImage *)backgroundImageForState:(KalTileState)state
{
  return [self attributeForKey:kAppearanceAttributes.backgroundImage state:state];
}

- (UIColor *)textColorForState:(KalTileState)state
{
  return [self attributeForKey:kAppearanceAttributes.textColor state:state];
}

- (UIColor *)shadowColorForState:(KalTileState)state
{
  return [self attributeForKey:kAppearanceAttributes.shadowColor state:state];
}

- (BOOL)reversesShadowForState:(KalTileState)state
{
  return [[self attributeForKey:kAppearanceAttributes.reversesShadow state:state] boolValue];
}

- (void)setShadowOffset:(CGSize)offset
{
    shadowOffset = offset;
    [self setNeedsDisplay];
}

#pragma mark -

+ (void)setAppearance:(NSMutableDictionary *)appearance value:(id)value forKey:(NSString *)key state:(KalTileState)state
{
  NSMutableDictionary *valueForState = [appearance objectForKey:key];
  if (valueForState == nil) {
    valueForState = [NSMutableDictionary dictionary];
    [appearance setObject:valueForState forKey:key];
  }
  [valueForState setObject:(value ?: [NSNull null]) forKey:[NSNumber numberWithInt:state]];
}

+ (BOOL)appearance:(NSDictionary *)appearance hasValue:(id *)outValue forKey:(NSString *)key state:(KalTileState)state
{
  NSDictionary *valueForState = [appearance objectForKey:key];
  if (!valueForState) { return NO; }
  
  // Returns the attribute with the highest number of common bits with state
  int maxNumberOfBits = -1;
  id bestValue = nil;
  
  for (NSNumber *stateNumber in valueForState) {
    int storedState = [stateNumber intValue];
  
    // does state match?
    if ((storedState & state) != storedState) { continue; }
  
    // does state match more ?
    int numberOfBits;
    for (numberOfBits = 0; storedState; numberOfBits++) { storedState &= storedState - 1; }
    if (numberOfBits <= maxNumberOfBits) { continue; }
  
    // best result so far :-)
    maxNumberOfBits = numberOfBits;
    bestValue = [valueForState objectForKey:stateNumber];
  }
  
  if (bestValue == nil) {
    return NO;
  }
  
  if (outValue) {
    *outValue = (bestValue == [NSNull null]) ? nil : bestValue;
  }
  return YES;
}

- (id)attributeForKey:(NSString *)key state:(KalTileState)state
{
  id value;
  
  if ([KalTileView appearance:appearance hasValue:&value forKey:key state:state]) {
    return value;
  }
  
  if ([KalTileView appearance:defaultAppearance hasValue:&value forKey:key state:state]) {
    return value;
  }
  
  return nil;
}

#pragma mark -

- (void)dealloc
{
  [date release];
  [appearance release];
  [super dealloc];
}

@end
