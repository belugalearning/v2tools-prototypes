//
//  RegularPinboard.m
//  Pinboard
//
//  Created by Alex Jeffreys on 09/05/2013.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import "RegularPinboard.h"
#import "Pin.h"


@interface RegularPinboard ()

@property (readwrite) int distanceBetweenPins;

@end

@implementation RegularPinboard {
    float rowHeight;
    float rowOffset;
    CGPoint anchorInPixels;
}

@synthesize distanceBetweenPins = distanceBetweenPins_, angleBetweenAxes = angleBetweenAxes_;

-(id)init {
    if (self = [super init]) {
        self.distanceBetweenPins = 20;
    }
    return self;
}

-(void)setupPins {
    anchorInPixels = ccp(self.background.anchorPoint.x * self.background.contentSize.width, self.background.anchorPoint.y * self.background.contentSize.height);
    rowHeight = sinf(self.angleBetweenAxes);
    rowOffset = cosf(self.angleBetweenAxes);
    
    int firstCoordinate = 0;
    int secondCoordinate = 0;
    while ([self positionOnBackground:[self pinPosition:0 with:secondCoordinate]]) {
        while ([self positionOnBackground:[self pinPosition:firstCoordinate with:secondCoordinate]]) {
            Pin * pin = [Pin pinWithX:firstCoordinate andY:secondCoordinate];
            [pin setPosition:[self pinPosition:firstCoordinate with:secondCoordinate]];
            [self.pins addObject:pin];
            firstCoordinate++;
        }
        firstCoordinate = -1;
        while ([self positionOnBackground:[self pinPosition:firstCoordinate with:secondCoordinate]]) {
            Pin * pin = [Pin pinWithX:firstCoordinate andY:secondCoordinate];
            [pin setPosition:[self pinPosition:firstCoordinate with:secondCoordinate]];
            [self.pins addObject:pin];
            firstCoordinate--;
        }
        firstCoordinate = 0;
        secondCoordinate++;
    }
    
    [super setupPins];
}

-(CGPoint)pinPosition:(int)i with:(int)j {
    float xValue = 10 + self.distanceBetweenPins * (i + rowOffset * j);
    float yValue = 10 + self.distanceBetweenPins * rowHeight * j;
    CGPoint pinPosition = ccp(xValue, yValue);
    return pinPosition;
}
            
            
-(BOOL)positionOnBackground:(CGPoint)pinPosition {
    CGPoint pinPositionRelativeToAnchor = ccp(pinPosition.x - anchorInPixels.x, pinPosition.y - anchorInPixels.y);
    BOOL onBackgound = CGRectContainsPoint(self.background.boundingBox, pinPositionRelativeToAnchor);
    return onBackgound;
}

@end
