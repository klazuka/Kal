//
//  NSMutableArrayAdditions.m
//  Kal
//
//  Created by Keith Lazuka on 12/18/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

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
