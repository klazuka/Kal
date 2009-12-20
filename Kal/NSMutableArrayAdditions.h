/* 
 * Copyright (c) 2009 Keith Lazuka
 * License: http://www.opensource.org/licenses/mit-license.html
 */

#import <Foundation/Foundation.h>


@interface NSMutableArray (KalAdditions)

- (void)enqueue:(id)anObject;
- (id)dequeue;

@end
