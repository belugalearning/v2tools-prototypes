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
#import "Angle.h"


@implementation Band {
    Pin * movingPin;
    BandPart * entryPart;
    BandPart * exitPart;
    BOOL showAngles;
    CCNode * angleNode;
}

@synthesize pins = pins_, bandParts = bandParts_, colour = colour_, bandNode = bandNode_, angles = angles_, anticlockwise = anticlockwise_, propertiesNode = propertiesNode_;

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
        
        
        self.propertiesNode = [CCNode node];
        self.propertiesNode.zOrder = 1;
        [self.bandNode addChild:self.propertiesNode];
        
        angleNode = [CCNode node];
        [self.propertiesNode addChild:angleNode];
        self.angles = [NSMutableArray array];
        showAngles = NO;
        angleNode.visible = NO;
        [self recalculateAngles];
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
    
    /*
    int numberOfBandParts = [self.bandParts count];
    for (int i = 0; i < numberOfBandParts; i++) {
        BandPart * bandPart = [self.bandParts objectAtIndex:i];
        BandPart * nextBandPart = [self.bandParts objectAtIndex:(i+1)%numberOfBandParts];
        Angle * angle = [Angle new];
        angle.position = bandPart.toPin.sprite.position;
    }
     */
    
    [self setAngles];
     
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

-(int)indexInCorrectRange:(int)index forArray:(NSArray *)array {
    int arraySize = [array count];
    int correctIndex;
    if (index < 0) {
        correctIndex =  index + arraySize;
    } else if (index >= arraySize) {
        correctIndex = index - arraySize;
    } else {
        correctIndex = index;
    }
    return correctIndex;
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
    [self setAngles];
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
    [self recalculateAngles];
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
    [self setAngles];
}

-(void)processEnd:(CGPoint)touchLocation {
    [movingPin.sprite removeFromParentAndCleanup:YES];
    movingPin = nil;
    entryPart = nil;
    exitPart = nil;
    [self setPositionAndRotationOfBandParts];
    [self cleanPins];
    [self setAngles];
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
    
    [self recalculateAngles];
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

-(void)showAngles {
    showAngles = !showAngles;
    angleNode.visible = showAngles;
}

-(void)recalculateAngles {
    int numberOfPins = [self.pins count];
    [self.angles removeAllObjects];
    [angleNode removeAllChildrenWithCleanup:YES];
    for (int i = 0; i < numberOfPins; i++) {
        Angle * angle = [Angle new];
        [self.angles addObject:angle];
        Pin * pin = [self.pins objectAtIndex:i];
        angle.position = pin.sprite.position;
        [angle setColourRed:self.colour.r green:self.colour.g blue:self.colour.b];
        [angleNode addChild:angle];
        angle.label = [CCLabelTTF labelWithString:@"" fontName:@"Arial" fontSize:12];
        angle.label.position = ccp(0, 10);
        [angle addChild:angle.label];
    }
}

-(void)setAngles {
    int numberOfPins = [self.pins count];
    float totalAngle = 0;
    for (int i = 0; i < numberOfPins; i++) {
        Angle * angle = [self.angles objectAtIndex:i];
        BandPart * inPart = [self.bandParts objectAtIndex:[self indexInCorrectRange:i-1 forArray:self.bandParts]];
        BandPart * outPart = [self.bandParts objectAtIndex:i];
        float inPartAngle = CC_DEGREES_TO_RADIANS(180 + inPart.baseNode.rotation);
        float outPartAngle = CC_DEGREES_TO_RADIANS(outPart.baseNode.rotation);
        angle.startAngle = inPartAngle;
        float thisAngle = [self angleInCorrectRange:outPartAngle - inPartAngle];
        angle.anticlockwise = self.anticlockwise;
        if (self.anticlockwise) {
            angle.throughAngle = thisAngle;
        } else {
            angle.throughAngle = 2*M_PI - thisAngle;
        }
        if (ABS(angle.throughAngle - 2 * M_PI) < 0.0001) {
            angle.throughAngle = 0;
        }
        Pin * pin = [self.pins objectAtIndex:i];
        angle.position = pin.sprite.position;
        totalAngle += M_PI - thisAngle;
        
        NSString * angleString = [NSString stringWithFormat:@"%.02f", CC_RADIANS_TO_DEGREES(angle.throughAngle)];
        [angle.label setString:angleString];
    }
    
    BOOL beforeAnticlockwise = self.anticlockwise;
    if (ABS(totalAngle) > 1) {
        if (totalAngle < 0 || ABS(totalAngle) < 1) {
            self.anticlockwise = NO;
        } else {
            self.anticlockwise = YES;
        }
    }
    
    if (beforeAnticlockwise != self.anticlockwise) {
        [self setAngles];
    }
}

-(float)angleInCorrectRange:(float)angle {
    angle = fmodf(angle, 2 * M_PI);
    if (angle < 0) {
        angle += 2 * M_PI;
    }
    return angle;
}


@end
