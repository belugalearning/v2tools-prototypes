//
//  ClockHandle.m
//  Clock3
//
//  Created by Alex Jeffreys on 02/05/2013.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import "ClockHandle.h"
#import "Time.h"
#import "AnalogueClock.h"

@implementation ClockHandle

@synthesize isHour;


-(void)processMove:(CGPoint)touchLocation {
    [clock processHandMove:touchLocation isHour:isHour];
}

-(AnalogueClock *)getClock {
    return clock;
}

-(void)setClock:(AnalogueClock *)clockToSet {
    clock = clockToSet;
}

@end
