//
//  ClockButton.h
//  Clock3
//
//  Created by Alex Jeffreys on 02/05/2013.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "TouchableSprite.h"


@class DigitalClock;
@interface ClockButton : TouchableSprite {
    BOOL changeHour;
    int valueToChange;
    BOOL isUp;
    DigitalClock * clock;
}

@property (readwrite, retain) DigitalClock * clock;
@property (readwrite) BOOL changeHour;
@property (readwrite) int valueToChange;
@property (readwrite) BOOL isUp;

@end
