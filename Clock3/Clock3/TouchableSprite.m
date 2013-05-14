//
//  TouchableSprite.m
//  Clock3
//
//  Created by Alex Jeffreys on 02/05/2013.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import "TouchableSprite.h"


@implementation TouchableSprite

-(BOOL)isTouching:(CGPoint)touchLocation {
    CGPoint relativeTouch = [sprite.parent convertToNodeSpace:touchLocation];
    return CGRectContainsPoint(sprite.boundingBox, relativeTouch);;
}

-(void)processTouch {
}

-(void)processMove:(CGPoint)touchLocation {
}

-(CCSprite *)getSprite {
    return sprite;
}

-(void)setSprite:(CCSprite *)spriteToSet {
    sprite = spriteToSet;
}

@end
