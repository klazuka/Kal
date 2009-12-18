//
//  NSMutableArrayAdditions.h
//  Kal
//
//  Created by Keith Lazuka on 12/18/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface NSMutableArray (KalAdditions)

- (void)enqueue:(id)anObject;
- (id)dequeue;

@end
