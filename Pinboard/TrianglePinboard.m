//
//  TrianglePinboard.m
//  Pinboard
//
//  Created by Alex Jeffreys on 09/05/2013.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import "TrianglePinboard.h"
#import "Pin.h"

@implementation TrianglePinboard

-(id)init {
    if (self = [super init]) {
        self.angleBetweenAxes = M_PI/3;
        [self setupPins];
    }
    return self;
}

+(id)pinboard {
    TrianglePinboard * pinboard = [TrianglePinboard new];
    return pinboard;
}

@end
