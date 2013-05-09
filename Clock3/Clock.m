//
//  Clock.m
//  Clock3
//
//  Created by Alex Jeffreys on 01/05/2013.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import "Clock.h"


@implementation Clock

@synthesize clockface, linkedClock;

-(void)setup {
    [NSException raise:@"Invoked abstract method" format:@"Invoked abstract method"];
}

-(void)setTime:(Time *)timeToSet {
    [NSException raise:@"Invoked abstract method" format:@"Invoked abstract method"];
}

-(void)setPosition:(CGPoint)point {
    clockface.position = point;
}

-(void)setScale:(float)scale {
    clockface.scale = scale;
}

-(void)addToNode:(CCNode *)node {
    [node addChild:clockface];
}

-(NSArray *)getTouchableSprites {
    [NSException raise:@"Invoked abstract method" format:@"Invoked abstract method"];
    return nil;
}


@end
