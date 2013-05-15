//
//  MyCocos2DClass.m
//  Pinboard
//
//  Created by Alex Jeffreys on 09/05/2013.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import "Pin.h"

@implementation Pin

@synthesize sprite = sprite_, x = x_, y = y_, circleIndex = circleIndex_;

-(id)init {
    if (self = [super init]) {
        self.sprite = [CCSprite spriteWithFile:@"pin.png"];
        //self.sprite.scale = 0.5;
    }
    return self;
}

-(void)addToNode:(CCNode *)node {
    [node addChild:self.sprite];
}

-(void)setPosition:(CGPoint)point {
    self.sprite.position = point;
}

+(id)pin {
    Pin * pin = [Pin new];
    return pin;
}

+(id)pinWithX:(int)x andY:(int)y {
    Pin * pin = [Pin new];
    pin.x = x;
    pin.y = y;
    return pin;
}

+(id)pinWithCircleIndex:(int)index {
    Pin * pin = [Pin new];
    pin.circleIndex = index;
    return pin;
}

-(void)drawLineTo:(Pin *)destinationPin {
    CCSprite * bandPart = [CCSprite spriteWithFile:@"bandPart.png"];
    bandPart.anchorPoint = ccp(0.5, 0);
    float angle = atan2f(destinationPin.sprite.position.x - self.sprite.position.x, destinationPin.sprite.position.y - self.sprite.position.y);
    bandPart.rotation = CC_RADIANS_TO_DEGREES(angle);
    CGPoint firstPosition = [self.sprite convertToNodeSpace:self.sprite.position];
    CGPoint secondPosition = [self.sprite convertToNodeSpace:destinationPin.sprite.position];
    float pinDistance = ccpDistance(firstPosition, secondPosition);
    float scaleFactor = pinDistance/bandPart.contentSize.height;
    bandPart.scaleY = scaleFactor;
    [self.sprite addChild:bandPart];
}

@end
