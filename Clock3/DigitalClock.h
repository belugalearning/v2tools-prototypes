//
//  DigitalClock.h
//  Clock3
//
//  Created by Alex Jeffreys on 01/05/2013.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "Clock.h"
#import "ClockButton.h"

@class AnalogueClock;
@interface DigitalClock : Clock {
    NSString * digitTextures[10];
    NSMutableArray * buttons;
    CCSprite * divider;
    CCSprite * digits[4];
    CCSprite * digitBlankTexture;
    CCSprite * pmIndicator;
    BOOL hour24;
}

@property (readwrite) BOOL hour24;

-(ClockButton *)getButton:(int)index;
-(void)processButtonClick:(ClockButton *)button;
-(id)initWithHour:(BOOL)hour24 andHourButtonsEnabled:(BOOL)hourEnabled andMinuteButtonsEnabled:(BOOL)minuteEnabled;

@end
