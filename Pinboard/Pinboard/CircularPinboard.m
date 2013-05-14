//
//  CircularPinboard.m
//  Pinboard
//
//  Created by Alex Jeffreys on 09/05/2013.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import "CircularPinboard.h"
#import "Pin.h"


@implementation CircularPinboard

@synthesize radius = radius_, numberOfPins = numberOfPins_, includeCentre = includeCentre_;

-(id)init {
    if (self = [super init]) {
        self.radius = 100;
        self.numberOfPins = 20;
        self.includeCentre = YES;
        [self setupPins];
    }
    return self;
}

+(id)pinboard {
    CircularPinboard * pinboard = [CircularPinboard new];
    return pinboard;
}

-(void)setupPins {
    CGPoint centreOfCircle = ccp(self.background.anchorPoint.x * self.background.contentSize.width, self.background.anchorPoint.x * self.background.contentSize.height);
    if (self.includeCentre) {
        Pin * pin = [Pin pin];
        [pin setPosition:centreOfCircle];
        [self.pins addObject:pin];
    }
    
    for (int i = 0; i < self.numberOfPins; i++) {
        Pin * pin = [Pin pinWithCircleIndex:i];
        float xValue = centreOfCircle.x + self.radius * sinf(2 * M_PI * (float)i/self.numberOfPins);
        float yValue = centreOfCircle.y + self.radius * cosf(2 * M_PI * (float)i/self.numberOfPins);
        [pin setPosition:ccp(xValue, yValue)];
        [self.pins addObject:pin];
    }
    
    [super setupPins];
}

@end
