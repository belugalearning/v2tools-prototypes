//
//  ClockButton.m
//  Clock3
//
//  Created by Alex Jeffreys on 02/05/2013.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import "ClockButton.h"
#import "Time.h"
#import "DigitalClock.h"


@implementation ClockButton

@synthesize changeHour;
@synthesize valueToChange;
@synthesize isUp;
@synthesize clock;

-(void)processTouch {
    [clock processButtonClick:self];
}


@end
