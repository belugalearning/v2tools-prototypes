//
//  Pinboard.m
//  Pinboard
//
//  Created by Alex Jeffreys on 09/05/2013.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import "Pinboard.h"
#import "Pin.h"


@implementation Pinboard

@synthesize background = background_, pins = pins_;

-(id)init {
    if (self = [super init]) {
        self.background = [CCSprite spriteWithFile:@"background.png"];
        self.pins = [NSMutableArray array];
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

@end
