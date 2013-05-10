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
        if (self.colour) {
            self.sprite.scale = 0.75;
        } else {
            self.sprite.scale = 0.5;
        }
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

@end
