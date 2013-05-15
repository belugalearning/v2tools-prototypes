//
//  BandPart.m
//  Pinboard
//
//  Created by Alex Jeffreys on 14/05/2013.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import "BandPart.h"
#import "Pin.h"
#import "Band.h"

@implementation BandPart

@synthesize sprite = _sprite, fromPin = _fromPin, toPin = _toPin, baseNode = _baseNode;

-(id)initWithBand:(Band *)band fromPin:(Pin *)fromPin toPin:(Pin *)toPin {
    if (self = [super init]) {
        self.baseNode = [CCNode node];
        self.band = band;
        self.sprite = [CCSprite spriteWithFile:@"bandPart.png"];
        self.sprite.anchorPoint = ccp(0.5, 0);
        [self.baseNode addChild:self.sprite];
        self.baseNode.anchorPoint = ccp(0.5, 0);
        self.sprite.color = band.colour;
        
        self.fromPin = fromPin;
        self.toPin = toPin;
    }
    return self;
}

-(void)setToBeFromPin:(Pin *)fromPin toPin:(Pin *)toPin {
    self.fromPin = fromPin;
    self.toPin = toPin;
}

+(id)bandPartWithBand:(Band *)band fromPin:(Pin *)fromPin toPin:(Pin *)toPin {
    BandPart * bandpart = [BandPart alloc];
    bandpart = [bandpart initWithBand:band fromPin:fromPin toPin:toPin];
    return bandpart;
}

-(NSArray *)adjacentPins {
    NSArray * adjacentPins = [[NSArray alloc] initWithObjects:self.fromPin, self.toPin, nil];
    return adjacentPins;
}

-(void)setPositionAndRotation {
    Pin * fromPin = self.fromPin;
    Pin * toPin = self.toPin;
    self.baseNode.position = fromPin.sprite.position;
    float angle = atan2f(toPin.sprite.position.x - fromPin.sprite.position.x,
                         toPin.sprite.position.y - fromPin.sprite.position.y);
    self.baseNode.rotation = CC_RADIANS_TO_DEGREES(angle);
    CGPoint fromPosition = [self.band.bandNode convertToNodeSpace:fromPin.sprite.position];
    CGPoint toPosition = [self.band.bandNode convertToNodeSpace:toPin.sprite.position];
    float pinDistance = ccpDistance(fromPosition, toPosition);
    float scaleFactor = pinDistance/self.sprite.contentSize.height;
    self.baseNode.scaleY = scaleFactor;
}

@end
