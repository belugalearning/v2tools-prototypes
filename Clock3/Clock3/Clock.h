//
//  Clock.h
//  Clock3
//
//  Created by Alex Jeffreys on 01/05/2013.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "Time.h"

typedef enum {
    digital,
    analogue,
    none
} ClockType;

@interface Clock : NSObject {
    CCSprite * clockface;
    Time * time;
    Clock * linkedClock;
}

@property (readonly) CCSprite * clockface;
@property (readwrite, retain) Clock * linkedClock;

-(void)setup;
-(void)setTime:(Time *)timeToSet;
-(void)setPosition:(CGPoint)point;
-(void)setScale:(float)scale;
-(void)addToNode:(CCNode *)node;
-(NSArray *)getTouchableSprites;

@end
