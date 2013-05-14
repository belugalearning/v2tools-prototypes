//
//  SquarePinboard.m
//  Pinboard
//
//  Created by Alex Jeffreys on 09/05/2013.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import "SquarePinboard.h"
#import "Pin.h"


@implementation SquarePinboard

-(id)init {
    if (self = [super init]) {
        self.angleBetweenAxes = M_PI_2;
        [self setupPins];
    }
    return self;
}

+(id)pinboard {
    SquarePinboard * pinboard = [SquarePinboard new];
    return pinboard;
}


@end
