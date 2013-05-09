//
//  MyCocos2DClass.m
//  Pinboard
//
//  Created by Alex Jeffreys on 09/05/2013.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import "Pin.h"


@implementation Pin

-(id)init {
    if (self = [super init]) {
        sprite = [CCSprite spriteWithFile:@"pin.png"];
    }
    return self;
}

@end
