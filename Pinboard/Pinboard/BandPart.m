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
#import "Pinboard.h"

@implementation BandPart {
    int numberOfIndicators;
}

@synthesize sprite = _sprite, fromPin = _fromPin, toPin = _toPin, baseNode = _baseNode, bandPartNode = bandPartNode_, notchNode = notchNode_, arrowNode = arrowNode_;

-(id)initWithBand:(Band *)band fromPin:(Pin *)fromPin toPin:(Pin *)toPin {
    if (self = [super init]) {
        self.baseNode = [CCNode node];
        self.notchNode = [CCNode node];
        self.arrowNode = [CCNode node];
        self.bandPartNode = [CCNode node];
        self.band = band;
        self.sprite = [CCSprite spriteWithFile:@"bandPart.png"];
        self.sprite.anchorPoint = ccp(0.5, 0);
        [self.bandPartNode addChild:self.sprite];
        self.baseNode.anchorPoint = ccp(0.5, 0);
        self.sprite.color = band.colour;
        
        self.fromPin = fromPin;
        self.toPin = toPin;

        [self.baseNode addChild:self.notchNode];
        [self.baseNode addChild:self.arrowNode];
        [self.baseNode addChild:self.bandPartNode];
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
    self.bandPartNode.position = fromPin.sprite.position;
    self.notchNode.position = self.bandPartNode.position;
    self.arrowNode.position = self.bandPartNode.position;
    float angle = atan2f(toPin.sprite.position.x - fromPin.sprite.position.x,
                         toPin.sprite.position.y - fromPin.sprite.position.y);
    self.bandPartNode.rotation = CC_RADIANS_TO_DEGREES(angle);
    self.notchNode.rotation = self.bandPartNode.rotation;
    self.arrowNode.rotation = self.bandPartNode.rotation;
    float pinDistance = [self pinDistance];
    float scaleFactor = pinDistance/self.sprite.contentSize.height;
    self.bandPartNode.scaleY = scaleFactor;
}

-(float)pinDistance {
    CGPoint fromPosition = [self.band.bandNode convertToNodeSpace:self.fromPin.sprite.position];
    CGPoint toPosition = [self.band.bandNode convertToNodeSpace:self.toPin.sprite.position];
    float pinDistance = ccpDistance(fromPosition, toPosition);
    return pinDistance;
}

-(float)length {
    float pinDistance = [self pinDistance];
    float distanceBetweenPins = [self.band.pinboard unitDistance];
    float length = pinDistance/distanceBetweenPins;
    return length;
}

-(BOOL)parallelTo:(BandPart *)otherPart {
    BOOL parallel;
    if (self.fromPin == self.toPin || otherPart.fromPin == otherPart.toPin) {
        parallel = NO;
    } else {
        float selfRun = self.toPin.sprite.position.x - self.fromPin.sprite.position.x;
        float selfRise = self.toPin.sprite.position.y - self.fromPin.sprite.position.y;
        float otherPartRun = otherPart.toPin.sprite.position.x - otherPart.fromPin.sprite.position.x;
        float otherPartRise = otherPart.toPin.sprite.position.y - otherPart.fromPin.sprite.position.y;
        float leftHandSide = selfRise * otherPartRun;
        float rightHandSide = otherPartRise * selfRun;
        if (ABS(leftHandSide - rightHandSide) < 0.001) {
            parallel = YES;
        } else {
            parallel = NO;
        }
    }
    return parallel;
}

-(void)addNotches:(int)numberOfNotches {
    numberOfIndicators = numberOfNotches;
    float spacing = 8;
    for (int i = 1; i <= numberOfNotches; i++) {
        CCSprite * sameSideLengthNotch = [CCSprite spriteWithFile:@"sameSideLengthNotch.png"];
        sameSideLengthNotch.rotation = 90;
        float yPosition = [self indicatorYPosition:i withSpacing:spacing];
        sameSideLengthNotch.position = ccp(0, yPosition);
        sameSideLengthNotch.color = self.band.colour;
        sameSideLengthNotch.visible = [self.band.sideDisplay isEqualToString:@"sameSideLengths"];
        [self.notchNode addChild:sameSideLengthNotch];
        [[self.band sameSideLengthNotches] addObject:sameSideLengthNotch];
    }
}

-(void)addArrows:(int)numberOfArrows {
    numberOfIndicators = numberOfArrows;
    float spacing = 8;
    for (int i = 1; i <= numberOfArrows; i++) {
        CCSprite * parallelSideArrow = [CCSprite spriteWithFile:@"parallelSideArrow.png"];
        parallelSideArrow.rotation = 90;
        parallelSideArrow.scale = 0.5;
        float yPosition = [self indicatorYPosition:i withSpacing:spacing];
        parallelSideArrow.position = ccp(0, yPosition);
        parallelSideArrow.color = self.band.colour;
        parallelSideArrow.visible = [self.band.sideDisplay isEqualToString:@"parallelSides"];
        [self.arrowNode addChild:parallelSideArrow];
        [[self.band parallelSideArrows] addObject:parallelSideArrow];
    }
}

-(float)indicatorYPosition:(int)index withSpacing:(float)spacing {
    float halfway = self.sprite.contentSize.height * self.bandPartNode.scaleY/2;
    float offset = (2*index-numberOfIndicators-1)*spacing/2;
    float yPosition = halfway + offset;
    return yPosition;
}

@end
