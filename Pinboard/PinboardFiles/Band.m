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


@implementation Band {
    CCNode * bandNode;
}

@synthesize pins = pins_, bandParts = bandParts_, colour = colour_;

-(id)initWithPinboard:(Pinboard *)pinboard andPins:(NSMutableArray *)pins {
    if (self = [super init]) {
        self.pinboard = pinboard;
        bandNode = [CCNode new];
        [self.pinboard.background addChild:bandNode];
        self.pins = pins;
        self.bandParts = [NSMutableArray array];
        
        int red = arc4random_uniform(255);
        int green = arc4random_uniform(255);
        int blue = arc4random_uniform(255);
        self.colour = ccc3(red, green, blue);
        
        [self drawBand];
        

         
    }
    return self;
    
}

-(void)drawBand {
    int numberOfPins = [self.pins count];
    if (numberOfPins > 1) {
        Pin * firstPin = [self.pins objectAtIndex:0];
        Pin * lastPin = [self.pins objectAtIndex:[self.pins count] - 1];
        [self addBandPartFrom:firstPin to:lastPin];
        for (int i = 1; i < numberOfPins; i++) {
            Pin * fromPin = [self.pins objectAtIndex:i - 1];
            Pin * toPin = [self.pins objectAtIndex:i];
            [self addBandPartFrom:fromPin to:toPin];
        }
    }
    for (int i = 0; i < numberOfPins; i++) {
        [bandNode addChild:[self.bandParts objectAtIndex:i]];
    }
}

-(void)addBandPartFrom:(Pin *)fromPin to:(Pin *)toPin {
    CCSprite * bandPart = [CCSprite spriteWithFile:@"bandPart.png"];
    bandPart.anchorPoint = ccp(0.5, 0);
    bandPart.position = fromPin.sprite.position;
    float angle = atan2f(toPin.sprite.position.x - fromPin.sprite.position.x, toPin.sprite.position.y - fromPin.sprite.position.y);
    bandPart.rotation = CC_RADIANS_TO_DEGREES(angle);
    CGPoint firstPosition = [bandNode convertToNodeSpace:fromPin.sprite.position];
    CGPoint secondPosition = [bandNode convertToNodeSpace:toPin.sprite.position];
    float pinDistance = ccpDistance(firstPosition, secondPosition);
    float scaleFactor = pinDistance/bandPart.contentSize.height;
    bandPart.scaleY = scaleFactor;
    bandPart.color = self.colour;
    [self.bandParts addObject:bandPart];
}

@end
