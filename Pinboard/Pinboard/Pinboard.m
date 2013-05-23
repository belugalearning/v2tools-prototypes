//
//  Pinboard.m
//  Pinboard
//
//  Created by Alex Jeffreys on 09/05/2013.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import "PinboardLayer.h"
#import "Pinboard.h"
#import "Pin.h"
#import "Band.h"
#import "CCSprite_SpriteTouchExtensions.h"
#import "Angle.h"
#import "BandPart.h"

@implementation Pinboard {
    Band * movingBand;
}

@synthesize background = background_, pins = pins_, layer = layer_;

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
        [self setPropertyIndicatorsFor:movingBand];
        [self recalculateSameSideLengths];
    }
    movingBand = nil;
}

-(void)setMovingBand:(Band *)band {
    movingBand = band;
    [self selectBand:band];
}

-(Band *)newBand {
    Pin * firstPin = [self.pins objectAtIndex:0];
    Pin * secondPin = [self.pins objectAtIndex:1];
    NSMutableArray * newBandPins = [NSMutableArray arrayWithObjects:firstPin, secondPin, nil];
    Band * band = [Band bandWithPinboard:self andPins:newBandPins];
    [band setupBand];
    [self selectBand:band];
    return band;
}

-(void)selectBandFromButton:(CCMenuItem *)sender {
    Band * band = sender.userObject;
    [self selectBand:band];
}

-(void)selectBand:(Band *)band {
    [self.bands removeObject:band];
    [self.bands insertObject:band atIndex:0];
    [self setBandsZIndexToPriorityOrder];
    [self setPropertyIndicatorsFor:band];
}

-(void)setBandsZIndexToPriorityOrder {
    int numberOfBands = [self.bands count];
    for (int i = 1; i <= numberOfBands; i++) {
        Band * band = [self.bands objectAtIndex:numberOfBands - i];
        [self.background reorderChild:band.bandNode z:i];
    }
}

-(void)showAngles {
    Band * band = [self.bands objectAtIndex:0];
    [band showAngles];
}

-(void)setCurrentBandSideDisplay:(NSString *)sideDisplay {
    Band * band = [self.bands objectAtIndex:0];
    [band toggleSideDisplay:sideDisplay];
}

-(void)setPropertyIndicatorsFor:(Band *)band {
    NSString * regular = [band regular];
    [self.layer setRegularIndicatorWithRegular:regular];
    NSString * shapeName = [band shape];
    [self.layer setShapeIndicatorWith:shapeName];
}

-(float)unitDistance {
    return 0;
}

-(void)recalculateSameSideLengths {
    NSMutableArray * allBands = self.bands;
    NSMutableArray * bandParts = [NSMutableArray array];
    for (Band * band in allBands) {
        if ([band.sideDisplay isEqualToString:@"sameSideLengths"]) {
            [band clearSameSideLengthNotches];
            if ([band.pins count] == 2) {
                [bandParts addObject:[band.bandParts objectAtIndex:0]];
            } else {
                [bandParts addObjectsFromArray:band.bandParts];
            }
        }
    }
    int numberOfNotches = 1;
    while ([bandParts count] > 0) {
        BandPart * bandPart = [bandParts objectAtIndex:0];
        NSMutableArray * sameLengthBandParts = [NSMutableArray array];
        [sameLengthBandParts addObject:bandPart];
        for (int i = 1; i < [bandParts count]; i++) {
            BandPart * otherBandPart = [bandParts objectAtIndex:i];
            if (ABS([bandPart length] - [otherBandPart length]) < 0.001) {
                [sameLengthBandParts addObject:otherBandPart];
            }
        }
        if ([sameLengthBandParts count] > 1) {
            for (BandPart * bandPart in sameLengthBandParts) {
                [bandPart addNotches:numberOfNotches];
            }
            numberOfNotches++;
        }
        for (BandPart * bandPart in sameLengthBandParts) {
            [bandParts removeObject:bandPart];
        }
    }
}

@end
