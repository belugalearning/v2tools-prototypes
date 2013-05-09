//
//  ClockHandle.h
//  Clock3
//
//  Created by Alex Jeffreys on 02/05/2013.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "TouchableSprite.h"

@class AnalogueClock;
@interface ClockHandle : TouchableSprite {
    BOOL isHour;
    AnalogueClock * clock;
}

@property (readwrite) BOOL isHour;

-(AnalogueClock *)getClock;
-(void)setClock:(AnalogueClock *)clockToSet;

@end
