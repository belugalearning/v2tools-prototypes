//
//  AnalogueClock.m
//  Clock3
//
//  Created by Alex Jeffreys on 01/05/2013.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import "AnalogueClock.h"
#import "Clock.h"
#import "TouchableSprite.h"
#import "ClockHandle.h"


@implementation AnalogueClock

@synthesize hourHandle, minuteHandle;

-(id)initWithHourHandEnabled:(BOOL)hourEnabled andMinuteHandEnabled:(BOOL)minuteEnabled andClockFaceType:(ClockfaceType)theClockfaceType {
    
    self = [super init];
    if (self) {
        
        clockface = [CCSprite spriteWithFile:@"Clock_Face.png"];
        
        NSString * clockfaceDesignFile;
        switch (theClockfaceType) {
            case all_numbers:
                clockfaceDesignFile = @"Clock_Numbers_All.png";
                break;
            case main_numbers:
                clockfaceDesignFile = @"Clock_Numbers_3-6-9-12.png";
                break;
            case all_words:
                clockfaceDesignFile = @"clockFaceAllWords.png";
                break;
            case main_words:
                clockfaceDesignFile = @"clockFaceMainWords.png";
                break;
            default:
                clockfaceDesignFile = nil;
                break;
        }
        
        CGPoint clockCentre = ccp(clockface.contentSize.width/2, clockface.contentSize.height * 103/200);
        
        if (theClockfaceType != blank) {
            CCSprite * clockfaceDesign = [CCSprite spriteWithFile:clockfaceDesignFile];
            clockfaceDesign.position = clockCentre;
            [clockface addChild:clockfaceDesign];
            
        }
        
        hourHand = [CCSprite spriteWithFile:@"Hour_hand.png"];
        hourHand.anchorPoint = ccp(0.5, 0.05);
        hourHand.position = clockCentre;
        hourHand.scale = 0.95;
        hourHand.zOrder = 1;
        [clockface addChild:hourHand];
        
        minuteHand = [CCSprite spriteWithFile:@"Minute_hand.png"];
        minuteHand.anchorPoint = ccp(0.5, 0.01);
        minuteHand.position = clockCentre;
        minuteHand.scale = 0.95;
        [clockface addChild:minuteHand];
        
        CCSprite * clockfacePin = [CCSprite spriteWithFile:@"Clock_Centre_Pin.png"];
        clockfacePin.position = clockCentre;
        clockfacePin.zOrder = 2;
        [clockface addChild:clockfacePin];
        
        if (hourEnabled) {
            hourHandle = [ClockHandle new];
            [hourHandle setSprite:[CCSprite spriteWithFile:@"Hour_hand_handle.png"]];
            [hourHandle setIsHour:YES];
            [hourHandle setClock:self];
            [hourHandle getSprite].position = ccp(hourHand.contentSize.width/2, hourHand.contentSize.height * 27/50);
            [hourHand addChild:[hourHandle getSprite]];
        }
        
        if (minuteEnabled) {
            minuteHandle = [ClockHandle new];
            [minuteHandle setSprite:[CCSprite spriteWithFile:@"Minute_hand_handle.png"]];
            [minuteHandle setIsHour:NO];
            [minuteHandle setClock:self];
            [minuteHandle getSprite].position = ccp(minuteHand.contentSize.width/2, minuteHand.contentSize.height/2);
            [minuteHand addChild:[minuteHandle getSprite]];
        }
    }
    return self;
}

-(void)setTime:(Time *)timeToSet {
    time = timeToSet;
    int timeInMinutes = 60 * timeToSet.hours + timeToSet.minutes;
    minuteHand.rotation = timeInMinutes * 6;
    hourHand.rotation = timeInMinutes * 1/2;

}

-(void)processHandMove:(CGPoint)touchLocation isHour:(BOOL)isHour {
    touchLocation = [clockface convertToNodeSpaceAR:touchLocation];
    float angle = atan2f(touchLocation.x, touchLocation.y);
    angle = CC_RADIANS_TO_DEGREES(angle);
    angle = [self angleInCorrectRange:angle];
    
    if (isHour) {
        int timeInMinutes = (int)floor(angle * 2);
        
        if (angle <= 90 && previousAngle >= 270) {
            [time changePm];
        } else if (angle >= 270 && previousAngle <= 90) {
            [time changePm];
        }
        if (time.pm) {
            timeInMinutes += 12 * 60;
        }
        [time setTime:timeInMinutes / 60 minutes:timeInMinutes % 60];
    } else {
        if (time.minutes > 45 && angle <= 90) {
            [time addHours:1];
        } else if (time.minutes < 15 && angle >= 270) {
            [time addHours:-1];
        }
        int minutes = floor((angle + 3)/6);
        [time setTime:time.hours minutes:minutes];
    }
    [self setTime:time];
    [linkedClock setTime:time];
    previousAngle = angle;
}

-(int)angleInCorrectRange:(float)angle {
    if (angle < 0) {
        angle += 360;
    }
    return angle;
}

-(NSArray *)getTouchableSprites {
    NSMutableArray * hands = [NSMutableArray new];
    [hands autorelease];
    if (hourHandle) {
        [hands addObject:hourHandle];
    }
    if (minuteHandle) {
        [hands addObject:minuteHandle];
    }
    return hands;
}

@end
