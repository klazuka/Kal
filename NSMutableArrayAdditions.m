/* 
 * Copyright (c) 2009 Keith Lazuka
 * License: http://www.opensource.org/licenses/mit-license.html
 */

#import "NSMutableArrayAdditions.h"


@implementation NSMutableArray (KalAdditions)

- (void)enqueue:(id)anObject
{
  [self insertObject:anObject atIndex:0];
}

- (id)dequeue
{
  id anObject = [[self lastObject] retain];
  [self removeLastObject];
  return [anObject autorelease];
}

@end
