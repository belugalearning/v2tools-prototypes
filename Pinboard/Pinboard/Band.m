//
//  Band.m
//  Pinboard
//
//  Created by Alex Jeffreys on 10/05/2013.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import "Band.h"
#import "Pinboard.h"
#import "Pin.h"
#import "BandPart.h"
#import "CCSprite_SpriteTouchExtensions.h"


@implementation Band {
    Pin * movingPin;
    BandPart * entryPart;
    BandPart * exitPart;
}

@synthesize pins = pins_, bandParts = bandParts_, colour = colour_, bandNode = bandNode_;

-(id)initWithPinboard:(Pinboard *)pinboard andPins:(NSMutableArray *)pins {
    if (self = [super init]) {
        self.pinboard = pinboard;
        [self.pinboard addBand:self];
        self.bandNode = [CCNode new];
        [self.pinboard.background addChild:self.bandNode];
        self.pins = pins;
        self.bandParts = [NSMutableArray array];
        
        int red = arc4random_uniform(255);
        int green = arc4random_uniform(255);
        int blue = arc4random_uniform(255);
        self.colour = ccc3(red, green, blue);
    }
    return self;
    
}

+(id)bandWithPinboard:(Pinboard *)pinboard andPins:(NSMutableArray *)pins {
    Band * band = [Band alloc];
    band = [band initWithPinboard:pinboard andPins:pins];
    return band;
}

-(void)setupBand {
    int numberOfPins = [self.pins count];
    if (numberOfPins > 1) {
        for (int i = 1; i < numberOfPins; i++) {
            Pin * fromPin = [self.pins objectAtIndex:i - 1];
            Pin * toPin = [self.pins objectAtIndex:i];
            [self addBandPartFrom:fromPin to:toPin withIndex:i - 1];
        }
        Pin * firstPin = [self.pins objectAtIndex:0];
        Pin * lastPin = [self.pins objectAtIndex:numberOfPins - 1];
        [self addBandPartFrom:lastPin to:firstPin withIndex:numberOfPins - 1];
    }
    [self setPositionAndRotationOfBandParts];
}

-(void)setPositionAndRotationOfBandParts {
    for (int i = 0; i < [self.bandParts count]; i++) {
        BandPart * bandPart = [self.bandParts objectAtIndex:i];
        [bandPart setPositionAndRotation];
    }
}

-(void)addBandPartFrom:(Pin *)fromPin to:(Pin *)toPin withIndex:(int)index {
    BandPart * bandpart = [BandPart bandPartWithBand:self fromPin:fromPin toPin:toPin];
    [self.bandParts insertObject:bandpart atIndex:index];
    [self.bandNode addChild:bandpart.baseNode];
}

-(NSArray *)pinsAdjacentToPin:(int)pinIndex {
    Pin * previousPin = [self.pins objectAtIndex:[self pinIndexInCorrectRange:pinIndex-1]];
    Pin * nextPin = [self.pins objectAtIndex:[self pinIndexInCorrectRange:pinIndex+1]];
    NSArray * adjacentPins = [NSArray arrayWithObjects: previousPin, nextPin, nil];
    return adjacentPins;
}

-(NSArray *)pinsAdjacentToBandPart:(int)bandPartIndex {
    BandPart * bandPart = [self.bandParts objectAtIndex:bandPartIndex];
    return [bandPart adjacentPins];
}

-(int)pinIndexInCorrectRange:(int)pinIndex {
    int numberOfPins = [self.pins count];
    int correctPinIndex;
    if (pinIndex < 0) {
        correctPinIndex =  pinIndex + numberOfPins;
    } else if (pinIndex >= numberOfPins) {
        correctPinIndex = pinIndex - numberOfPins;
    } else {
        correctPinIndex = pinIndex;
    }
    return correctPinIndex;
}

-(void)processTouch:(CGPoint)touchLocation {
    BOOL pinSelected = NO;
    for (int i = 0; i < [self.pins count]; i++) {
        Pin * pin = [self.pins objectAtIndex:i];
        if ([pin.sprite touched:touchLocation]) {
            if ([self.pins count] > 1) {
                [self unpinBandFromPin:i];
            } else {
                [self splitBandPart:0 at:touchLocation];
            }
            pinSelected = YES;
            [self.pinboard setMovingBand:self];
            break;
        }
    }
    if (!pinSelected) {
        int numberOfBandParts = [self.bandParts count];
        for (int i = 0; i < numberOfBandParts; i++) {
            BandPart * bandPart = [self.bandParts objectAtIndex:i];
            if ([bandPart.sprite touched:touchLocation]) {
                [self splitBandPart:i at:touchLocation];
                [self.pinboard setMovingBand:self];
                break;
            }
        }
    }
    [self setPositionAndRotationOfBandParts];
    
}

-(void)splitBandPart:(int)index at:(CGPoint)touchLocation {
    
    
    BandPart * bandPart = [self.bandParts objectAtIndex:index];
    
    movingPin = [Pin pin];
    CGPoint pinPosition = [self.bandNode convertToNodeSpace:touchLocation];
    movingPin.sprite.position = pinPosition;
    [self.bandNode addChild:movingPin.sprite];
    Pin * previousPin = bandPart.fromPin;
    Pin * nextPin = bandPart.toPin;
    int movingPinIndex = [self.pins indexOfObject:nextPin];
    [self.pins insertObject:movingPin atIndex:movingPinIndex];
        [self.bandParts removeObjectAtIndex:index];
    if (movingPinIndex == 0) {
                [self addBandPartFrom:previousPin to:movingPin withIndex:index];
        entryPart = [self.bandParts objectAtIndex:index];
        [self addBandPartFrom:movingPin to:nextPin withIndex:0];
        exitPart = [self.bandParts objectAtIndex:0];

    } else {
        [self addBandPartFrom:movingPin to:nextPin withIndex:index];
        [self addBandPartFrom:previousPin to:movingPin withIndex:index];
         int numberOfBandParts = [self.bandParts count];
        entryPart = [self.bandParts objectAtIndex:index];
        exitPart = [self.bandParts objectAtIndex:(index + 1)%numberOfBandParts];

    }
   
    
    [bandPart.sprite.parent removeFromParentAndCleanup:YES];

}

-(void)unpinBandFromPin:(int)index {
    Pin * pin = [self.pins objectAtIndex:index];
    movingPin = [Pin pin];
    movingPin.sprite.position = pin.sprite.position;
    [self.bandNode addChild:movingPin.sprite];
    [self.pins replaceObjectAtIndex:index withObject:movingPin];
    
    int entryPartIndex;
    if (index == 0) {
        entryPartIndex = [self.bandParts count] - 1;
    } else {
        entryPartIndex = index - 1;
    }
    entryPart = [self.bandParts objectAtIndex:entryPartIndex];
    exitPart = [self.bandParts objectAtIndex:index];
    [entryPart setToBeFromPin:entryPart.fromPin toPin:movingPin];
    [exitPart setToBeFromPin:movingPin toPin:exitPart.toPin];
}

-(void)setEntryAndExitPartsForPin:(Pin *)pin {
    int numberOfBandParts = [self.bandParts count];
    for (int i = 0; i < numberOfBandParts; i++) {
        BandPart * bandPart = [self.bandParts objectAtIndex:i];
        if (bandPart.toPin == pin) {
            entryPart = bandPart;
            exitPart = [self.bandParts objectAtIndex:(i+1)%numberOfBandParts];
            break;
        }
    }
}

-(void)processMove:(CGPoint)touchLocation {
    
    movingPin.sprite.position = touchLocation;
    [self setPositionAndRotationOfBandParts];
}

-(void)processEnd:(CGPoint)touchLocation {
    [movingPin.sprite removeFromParentAndCleanup:YES];
    movingPin = nil;
    entryPart = nil;
    exitPart = nil;
    [self setPositionAndRotationOfBandParts];
    [self cleanPins];
}

-(void)pinBandOnPin:(Pin *)pin {
    [entryPart setToBeFromPin:entryPart.fromPin toPin:pin];
    [exitPart setToBeFromPin:pin toPin:exitPart.toPin];
    int movingPinIndex = [self.pins indexOfObject:movingPin];
    [self.pins replaceObjectAtIndex:movingPinIndex withObject:pin];
    [self setPositionAndRotationOfBandParts];
}

-(void)removeMovingPin {
    Pin * fromPin = entryPart.fromPin;
    Pin * toPin = exitPart.toPin;
    
    int index = [self.bandParts indexOfObject:entryPart];
    [self addBandPartFrom:fromPin to:toPin withIndex:index];
    
    [self.bandParts removeObject:entryPart];
    [self.bandParts removeObject:exitPart];
    [self.pins removeObject:movingPin];
    [entryPart.sprite removeFromParentAndCleanup:YES];
    [exitPart.sprite removeFromParentAndCleanup:YES];
    [movingPin.sprite removeFromParentAndCleanup:YES];
}

-(void)cleanPins {
    if ([self.pins count] > 1) {
        int numberOfPins = [self.pins count];
        NSMutableIndexSet * repeatPinsIndexes = [NSMutableIndexSet indexSet];
        for (int i = 0; i < numberOfPins; i++) {
            Pin * currentPin = [self.pins objectAtIndex:i];
            Pin * nextPin = [self.pins objectAtIndex:(i + 1)%numberOfPins];
            if (currentPin == nextPin) {
                [repeatPinsIndexes addIndex:i];
                BandPart * bandPart = [self.bandParts objectAtIndex:i];
                [bandPart.sprite.parent removeFromParentAndCleanup:YES];
            }
        }
        [self.pins removeObjectsAtIndexes:repeatPinsIndexes];
        [self.bandParts removeObjectsAtIndexes:repeatPinsIndexes];
    }
    
    /*
    numberOfPins = [self.pins count];
    NSMutableIndexSet * straightThroughPinsIndexes = [NSMutableIndexSet indexSet];
    for (int i = 0; i < numberOfPins; i++) {
        BandPart * thisPart = [self.bandParts objectAtIndex:i];
        BandPart * nextPart = [self.bandParts objectAtIndex:(i + 1)%numberOfPins];
        if (thisPart.sprite.parent.rotation == nextPart.sprite.parent.rotation) {
            [straightThroughPinsIndexes addIndex:(i+1)%numberOfPins];
        }
    }
    [self.pins removeObjectsAtIndexes:repeatPinsIndexes];
    [self setPositionAndRotationOfBandParts];
     */
}


@end
