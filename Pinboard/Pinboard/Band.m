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
    CCNode * angleNode;
    CCNode * sideLengthsNode;
    NSMutableArray * sideLengthLabels;
}

@synthesize pins = pins_, bandParts = bandParts_, colour = colour_, bandNode = bandNode_, angles = angles_, anticlockwise = anticlockwise_, propertiesNode = propertiesNode_, sideDisplay = sideDisplay_, angleDisplay = angleDisplay_, sameSideLengthNotches = sameSideLengthNotches_, parallelSideArrows = parallelSideArrows_;

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
        
        sideLengthLabels = [NSMutableArray array];
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
    [self setupPropertiesNode];
}

-(void)setupPropertiesNode {
    self.propertiesNode = [CCNode node];
    self.propertiesNode.zOrder = 1;
    [self.bandNode addChild:self.propertiesNode];
    
    self.sideDisplay = @"none";
    
    sideLengthsNode = [CCNode node];
    [self.propertiesNode addChild:sideLengthsNode];
    sideLengthsNode.visible = NO;
    [self recalculateSideLengths];

    self.sameSideLengthNotches = [NSMutableArray array];
    [self.pinboard recalculateSameSideLengths];
    
    self.angleDisplay = @"none";
    
    self.parallelSideArrows = [NSMutableArray array];
    [self.pinboard recalculateParallelSides];
    
    angleNode = [CCNode node];
    [self.propertiesNode addChild:angleNode];
    self.angles = [NSMutableArray array];
    angleNode.visible = NO;
    [self recalculateAngles];
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
    BOOL selected = NO;
    for (int i = 0; i < [self.pins count]; i++) {
        Pin * pin = [self.pins objectAtIndex:i];
        if ([pin.sprite touched:touchLocation]) {
            if ([self.pins count] > 1) {
                [self unpinBandFromPin:i];
            } else {
                [self splitBandPart:0 at:touchLocation];
            }
            selected = YES;
            [self.pinboard setMovingBand:self];
            break;
        }
    }
    if (!selected) {
        int numberOfBandParts = [self.bandParts count];
        for (int i = 0; i < numberOfBandParts; i++) {
            BandPart * bandPart = [self.bandParts objectAtIndex:i];
            if ([bandPart.sprite touched:touchLocation]) {
                [self splitBandPart:i at:touchLocation];
                [self.pinboard setMovingBand:self];
                selected = YES;
                break;
            }
        }
    }
    if (selected) {
        [self setPositionAndRotationOfBandParts];
        [self setAngles];
        [self setSideLengths];
        [self clearSameSideLengthNotches];
        [self clearParallelSideArrows];
    }
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
    [self recalculateSideLengths];
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
    [self recalculateAngles];
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
    [self setSideLengths];
}

-(void)processEnd:(CGPoint)touchLocation {
    [movingPin.sprite removeFromParentAndCleanup:YES];
    movingPin = nil;
    entryPart = nil;
    exitPart = nil;
    [self setPositionAndRotationOfBandParts];
    [self cleanPins];
    [self setAngles];
    [self setSideLengths];
}

-(void)pinBandOnPin:(Pin *)pin {
    [entryPart setToBeFromPin:entryPart.fromPin toPin:pin];
    [exitPart setToBeFromPin:pin toPin:exitPart.toPin];
    int movingPinIndex = [self.pins indexOfObject:movingPin];
    [self.pins replaceObjectAtIndex:movingPinIndex withObject:pin];
    [self setPositionAndRotationOfBandParts];

}

-(void)removeMovingPin {
    int index = [self.pins indexOfObject:movingPin];
    [self removePin:index];
    [movingPin.sprite removeFromParentAndCleanup:YES];
    [self recalculateAngles];
    [self recalculateSideLengths];
}

-(void)removePin:(int)pinIndex {
    Pin * pin = [self.pins objectAtIndex:pinIndex];
    BandPart * inPart = [self.bandParts objectAtIndex:[self indexInCorrectRange:pinIndex - 1 forArray:self.bandParts]];
    BandPart * outPart = [self.bandParts objectAtIndex:pinIndex];
    Pin * fromPin = inPart.fromPin;
    Pin * toPin = outPart.toPin;
    
    [self addBandPartFrom:fromPin to:toPin withIndex:[self indexInCorrectRange:pinIndex - 1 forArray:self.bandParts]];
    [self.bandParts removeObject:inPart];
    [self.bandParts removeObject:outPart];
    [self.pins removeObject:pin];
    [inPart.sprite removeFromParentAndCleanup:YES];
    [outPart.sprite removeFromParentAndCleanup:YES];
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
        
        int indexOfStraightThroughPin = [self indexOfStraightThroughPin];
        while (indexOfStraightThroughPin != -1) {
            [self removePin:indexOfStraightThroughPin];
            [self setPositionAndRotationOfBandParts];
            indexOfStraightThroughPin = [self indexOfStraightThroughPin];
        }
        [self setPositionAndRotationOfBandParts];
        [self recalculateAngles];
        [self recalculateSideLengths];
    }
}

-(int)indexOfStraightThroughPin {
    int numberOfPins = [self.pins count];
    int indexToReturn = -1;
    for (int i = 0; i < numberOfPins; i++) {
        BandPart * thisPart = [self.bandParts objectAtIndex:i];
        BandPart * nextPart = [self.bandParts objectAtIndex:(i+1)%numberOfPins];
        if ([self aFloat:thisPart.sprite.parent.rotation closeTo:nextPart.sprite.parent.rotation]) {
            indexToReturn = (i+1)%numberOfPins;
        }
    }
    return indexToReturn;
}

-(void)recalculateAngles {
    int numberOfPins = [self.pins count];
    [self.angles removeAllObjects];
    [angleNode removeAllChildrenWithCleanup:YES];
    for (int i = 0; i < numberOfPins; i++) {
        Angle * angle = [Angle new];
        angle.displaySameAngles = [self.angleDisplay isEqualToString:@"sameAngles"];
        [self.angles addObject:angle];
        Pin * pin = [self.pins objectAtIndex:i];
        angle.position = pin.sprite.position;
        [angle setColourRed:self.colour.r green:self.colour.g blue:self.colour.b];
        [angleNode addChild:angle];
        angle.label = [CCLabelTTF labelWithString:@"" fontName:@"Arial" fontSize:12];
        angle.label.visible = !angle.displaySameAngles;
        angle.label.position = ccp(0, 10);
        [angle addChild:angle.label];
    }
    [self setAngles];
}

-(void)setAngles {
    int numberOfPins = [self.pins count];
    float totalAngle = 0;
    for (int i = 0; i < numberOfPins; i++) {
        Angle * angle = [self.angles objectAtIndex:i];
        BandPart * inPart = [self.bandParts objectAtIndex:[self indexInCorrectRange:i-1 forArray:self.bandParts]];
        BandPart * outPart = [self.bandParts objectAtIndex:i];
        float inPartAngle = CC_DEGREES_TO_RADIANS(180 + inPart.bandPartNode.rotation);
        float outPartAngle = CC_DEGREES_TO_RADIANS(outPart.bandPartNode.rotation);
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

-(void)toggleAngleDisplay:(NSString *)angleDisplay {
    if (![self.angleDisplay isEqualToString:angleDisplay]) {
        self.angleDisplay = angleDisplay;
    } else {
        self.angleDisplay = @"none";
    }
    [self displayAngles];
}

-(void)toggleSideDisplay:(NSString *)sideDisplay {
    if (![self.sideDisplay isEqual:sideDisplay]) {
        self.sideDisplay = sideDisplay;
    } else {
        self.sideDisplay = @"none";
    }
    [self displaySides];
}

-(void)displaySides {
    sideLengthsNode.visible = NO;
    [self sameSideLengthNotchesVisible:NO];
    [self parallelSideArrowsVisible:NO];
    if ([self.sideDisplay isEqualToString:@"sideLengths"]) {
        sideLengthsNode.visible = YES;
    } else if ([self.sideDisplay isEqualToString:@"sameSideLengths"]) {
        [self sameSideLengthNotchesVisible:YES];
    } else if ([self.sideDisplay isEqualToString:@"parallelSides"]) {
        [self parallelSideArrowsVisible:YES];
    }
}

-(void)displayAngles {
    if ([self.angleDisplay isEqualToString:@"none"]) {
        angleNode.visible = NO;
    } else if ([self.angleDisplay isEqualToString:@"angles"]) {
        for (Angle * angle in self.angles) {
            angle.displaySameAngles = NO;
        }
        angleNode.visible = YES;
    } else if ([self.angleDisplay isEqualToString:@"sameAngles"]) {
        for (Angle * angle in self.angles) {
            angle.displaySameAngles = YES;
        }
        angleNode.visible = YES;
    }
}

-(void)recalculateSideLengths {
    int numberOfBandParts = [self.bandParts count];
    [sideLengthsNode removeAllChildrenWithCleanup:YES];
    [sideLengthLabels removeAllObjects];
    for (int i = 0; i < numberOfBandParts; i++) {
        CCLabelTTF * label = [CCLabelTTF labelWithString:@"" fontName:@"Arial" fontSize:12];
        label.color = ccc3(0, 0, 0);
        CCSprite * labelBackground = [CCSprite spriteWithFile:@"sideLengthBackground.png"];
        labelBackground.color = self.colour;
        [sideLengthLabels addObject:label];
        label.position = ccp(labelBackground.contentSize.width * labelBackground.scaleX/2, labelBackground.contentSize.height * labelBackground.scaleY/2);
        [labelBackground addChild:label];
        [sideLengthsNode addChild:labelBackground];
    }
    [self setSideLengths];
}

-(void)setSideLengths {
    int numberOfBandParts = [self.bandParts count];
    for (int i = 0; i < numberOfBandParts; i++) {
        BandPart * bandPart = [self.bandParts objectAtIndex:i];
        float length = [bandPart length];
        NSString * lengthString = [NSString stringWithFormat:@"%.02f", length];
        CCLabelTTF * label = [sideLengthLabels objectAtIndex:i];
        float labelXPosition = (bandPart.fromPin.sprite.position.x + bandPart.toPin.sprite.position.x)/2.0;
        float labelYPosition = (bandPart.fromPin.sprite.position.y + bandPart.toPin.sprite.position.y)/2.0;
        label.parent.position = ccp(labelXPosition, labelYPosition);
        [label setString:lengthString];
    }
}

-(void)clearSameSideLengthNotches {
    for (CCSprite * notch in self.sameSideLengthNotches) {
        [notch removeFromParentAndCleanup:YES];
    }
    [self.sameSideLengthNotches removeAllObjects];
}

-(void)sameSideLengthNotchesVisible:(BOOL)visible {
    for (BandPart * bandPart in self.bandParts) {
        bandPart.notchNode.visible = visible;
    }
}

-(void)clearParallelSideArrows {
    for (CCSprite * arrow in self.parallelSideArrows) {
        [arrow removeFromParentAndCleanup:YES];
    }
    [self.parallelSideArrows removeAllObjects];
}

-(void)parallelSideArrowsVisible:(BOOL)visible {
    for (BandPart * bandPart in self.bandParts) {
        bandPart.arrowNode.visible = visible;
    }
}

-(NSString *)regular {
    NSString * regular;
    if ([self.bandParts count] < 3) {
        regular = @"";
    } else {
        regular = @"Regular";
        BandPart * firstBandPart = [self.bandParts objectAtIndex:0];
        float sideLength = [firstBandPart length];
        for (BandPart * bandPart in self.bandParts) {
            float thisLength = [bandPart length];
            if (ABS(thisLength - sideLength) > 0.0001) {
                regular = @"Irregular";
                break;
            }
        }
        if (regular) {
            Angle * angle = [self.angles objectAtIndex:0];
            float angleValue = angle.throughAngle;
            for (Angle * angle in self.angles) {
                float thisAngleValue = angle.throughAngle;
                if (ABS(thisAngleValue - angleValue) > 0.0001) {
                    regular = @"Irregular";
                    break;
                }
            }
        }
    }
    return regular;
}

-(NSString *)shape {
    int numberOfSides = [self.bandParts count];
    NSString * shapeName;
    
    switch (numberOfSides) {
        case 3:
            shapeName = [self triangleName];
            break;
        case 4:
            shapeName = [self quadrilateralName];
            break;
        case 5:
            shapeName = @"Pentagon";
            break;
        case 6:
            shapeName = @"Hexagon";
            break;
        case 7:
            shapeName = @"Heptagon";
            break;
        case 8:
            shapeName = @"Octagon";
            break;
        case 9:
            shapeName = @"Nonagon";
            break;
        case 10:
            shapeName = @"Decagon";
            break;
        default:
            if (numberOfSides < 3) {
                shapeName = @"";
            } else if (numberOfSides > 10) {
                shapeName = @"Polygon";
            }
            break;
    }
    return shapeName;
}

-(NSString *)triangleName {
    NSString * triangleName;
    float sides[3];
    for (int i = 0; i < 3; i++) {
        BandPart * bandPart = [self.bandParts objectAtIndex:i];
        sides[i] = [bandPart length];
    }
    if ([self aFloat:sides[0] closeTo:sides[1]] && [self aFloat:sides[1] closeTo:sides[2]]) {
        triangleName = @"Equilateral triangle";
    } else if ([self aFloat:sides[0] closeTo:sides[1]]
               || [self aFloat:sides[1] closeTo:sides[2]]
               || [self aFloat:sides[2] closeTo:sides[0]]) {
        triangleName = @"Isosceles triangle";
    } else {
        triangleName = @"Scalene triangle";
    }
    return triangleName;
}

-(NSString *)quadrilateralName {
    NSString * quadrilateralName;
    float angles[4];
    BOOL allRightAngles = YES;
    for (int i = 0; i < 4; i++) {
        Angle * angle = [self.angles objectAtIndex:i];
        angles[i] = angle.throughAngle;
        if (![self aFloat:angle.throughAngle closeTo:M_PI_2]) {
            allRightAngles = NO;
        }
    }
    float sides[4];
    BandPart * firstSide = [self.bandParts objectAtIndex:0];
    sides[0] = [firstSide length];
    BOOL sidesEqual = YES;
    for (int i = 0; i < 4; i++) {
        BandPart * bandPart = [self.bandParts objectAtIndex:i];
        sides[i] = [bandPart length];
        if (![self aFloat:sides[i] closeTo:sides[0]]) {
            sidesEqual = NO;
        }
    }
    
    if (allRightAngles) {
        if (sidesEqual) {
            quadrilateralName = @"Square";
        } else {
            quadrilateralName = @"Rectangle";
        }
    } else {
        if (sidesEqual) {
            quadrilateralName = @"Rhombus";
        } else if ([[self.bandParts objectAtIndex:0] parallelTo:[self.bandParts objectAtIndex:2]]
                   && [[self.bandParts objectAtIndex:1] parallelTo:[self.bandParts objectAtIndex:3]]) {
                quadrilateralName = @"Parallelogram";
        } else if (([self aFloat:sides[0] closeTo:sides[1]] && [self aFloat:sides[2] closeTo:sides[3]])
                   || ([self aFloat:sides[1] closeTo:sides[2]] && [self aFloat:sides[3] closeTo:sides[0]])) {
            quadrilateralName = @"Kite";
        } else if ([[self.bandParts objectAtIndex:0] parallelTo:[self.bandParts objectAtIndex:2]]
                   || [[self.bandParts objectAtIndex:1] parallelTo:[self.bandParts objectAtIndex:3]]) {
            quadrilateralName = @"Trapezium";
        } else {
            quadrilateralName = @"Quadrilateral";
        }
    }
    return quadrilateralName;
}

-(BOOL)aFloat:(float)firstFloat closeTo:(float)secondFloat {
    return ABS(firstFloat - secondFloat) < 0.001;
}




@end
