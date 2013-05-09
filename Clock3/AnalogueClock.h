//
//  AnalogueClock.h
//  Clock3
//
//  Created by Alex Jeffreys on 01/05/2013.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "ClockHandle.h"
#import "Clock.h"

@class DigitalClock;

typedef enum {
    blank,
    all_numbers,
    main_numbers,
    all_words,
    main_words
} ClockfaceType;

@interface AnalogueClock : Clock {
    CCSprite * minuteHand;
    ClockHandle * minuteHandle;
    CCSprite * hourHand;
    ClockHandle * hourHandle;
    float previousAngle;
    ClockfaceType clockfaceType;
}

@property (readonly) ClockHandle * hourHandle;
@property (readonly) ClockHandle * minuteHandle;
@property (readwrite) enum clockfaceType;

-(void)processHandMove:(CGPoint)touchLocation isHour:(BOOL)isHour;
-(id)initWithHourHandEnabled:(BOOL)hourEnabled andMinuteHandEnabled:(BOOL)minuteEnabled andClockFaceType:(ClockfaceType)theClockfaceType;

@end
