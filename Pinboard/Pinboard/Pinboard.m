//
//  Pinboard.m
//  Pinboard
//
//  Created by Alex Jeffreys on 09/05/2013.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import "Pinboard.h"
#import "Pin.h"
#import "Band.h"
#import "CCSprite_SpriteTouchExtensions.h"

@implementation Pinboard {
    Band * movingBand;
}

@synthesize background = background_, pins = pins_;

-(id)init {
    if (self = [super init]) {
        self.background = [CCSprite spriteWithFile:@"background.png"];
        self.pins = [NSMutableArray array];
        self.bands = [NSMutableArray array];
    }
    return self;
}

-(void)addPinsToBackground {
    for (Pin * pin in self.pins) {
        [pin addToNode:self.background];
    }
}

-(void)addToNode:(CCNode *)node {
    [node addChild:self.background];
}

-(void)setPosition:(CGPoint)position {
    [self.background setPosition:position];
}

+(id)pinboard {
    Pinboard * pinboard = [Pinboard new];
    return pinboard;
}

-(void)setupPins {
    [self addPinsToBackground];
}

-(void)addBand:(Band *)band {
    [band setPinboard:self];
    [self.bands addObject:band];
}

-(void)processTouch:(CGPoint)touchLocation {
    for (int i = 0; i < [self.bands count]; i++) {
        Band * band = [self.bands objectAtIndex:i];
        [band processTouch:touchLocation];
        if (movingBand != nil) {
            break;
        }
    }
}

-(void)processMove:(CGPoint)touchLocation {
    if (movingBand != nil) {
        touchLocation = [self.background convertToNodeSpace:touchLocation];
        [movingBand processMove:touchLocation];
    }
}

-(void)processEnd:(CGPoint)touchLocation {
    if (movingBand != nil) {
        BOOL placedOnPin = NO;
        for (int i = 0; i < [self.pins count]; i++) {
            Pin * pin = [self.pins objectAtIndex:i];
            if ([pin.sprite touched:touchLocation]) {
                [movingBand pinBandOnPin:pin];
                placedOnPin = YES;
            }
        }
        if (!placedOnPin) {
            [movingBand removeMovingPin];
        }
        [movingBand processEnd:touchLocation];
    }
    movingBand = nil;
}

-(void)setMovingBand:(Band *)band {
    movingBand = band;
}

-(void)newBand {
    Pin * firstPin = [self.pins objectAtIndex:0];
    Pin * secondPin = [self.pins objectAtIndex:1];
    NSMutableArray * newBandPins = [NSMutableArray arrayWithObjects:firstPin, secondPin, nil];
    Band * band = [Band bandWithPinboard:self andPins:newBandPins];
    [band setupBand];
}

@end
