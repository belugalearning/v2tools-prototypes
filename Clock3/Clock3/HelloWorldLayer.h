//
//  HelloWorldLayer.h
//  Clock3
//
//  Created by Alex Jeffreys on 26/04/2013.
//  Copyright __MyCompanyName__ 2013. All rights reserved.
//


#import <GameKit/GameKit.h>

// When you import this file, you import all the cocos2d classes
#import "cocos2d.h"
#import "TouchableSprite.h"
#import "Time.h"
#import "AnalogueClock.h"

typedef enum {
    analogue_then_digital,
    digital_then_analogue,
    one_digital,
    one_analogue,
    two_digital,
    two_analogue
} ClockDisplays;

// HelloWorldLayer
@interface HelloWorldLayer : CCLayer <GKAchievementViewControllerDelegate, GKLeaderboardViewControllerDelegate>
{
    
    BOOL clock1hour24;
    BOOL clock2hour24;
    BOOL clocksIndependent;
    BOOL clock1MinuteEnabled;
    BOOL clock1HourEnabled;
    BOOL clock2HourEnabled;
    BOOL clock2MinuteEnabled;
    BOOL bothStartFromRandom;
    BOOL clock1StartFromRandom;
    BOOL clock2StartFromRandom;
    
    Time * initialBothTime;
    Time * initialClock1Time;
    Time * initialClock2Time;
    
    NSTimer * repeatTouch;
    ClockfaceType clockfaceType;
    ClockType clock1Type;
    ClockType clock2Type;
    
    NSMutableArray * touchableSprites;
    TouchableSprite * selectedSprite;
}


// returns a CCScene that contains the HelloWorldLayer as the only child
+(CCScene *) scene;

@end