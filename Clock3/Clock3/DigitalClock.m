//
//  DigitalClock.m
//  Clock3
//
//  Created by Alex Jeffreys on 01/05/2013.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import "DigitalClock.h"


@implementation DigitalClock

@synthesize hour24;

-(id)initWithHour:(BOOL)isHour24 andHourButtonsEnabled:(BOOL)hourEnabled andMinuteButtonsEnabled:(BOOL)minuteEnabled {
    self = [super init];
    if (self) {
        hour24 = isHour24;
        
        clockface = [CCSprite spriteWithFile:@"digital_bg.png"];
        divider = [CCSprite spriteWithFile:@"colon.png"];
        //divider.anchorPoint = ccp(0, 0);
        divider.position = ccp(220, 80);
        [clockface addChild:divider];

        //[self performSelector:@selector(blinkOff)];
        
        CCBlink * blinkOnce = [CCBlink actionWithDuration:2 blinks:1];
        CCRepeatForever * continuousBlink = [CCRepeatForever actionWithAction:blinkOnce];
        [divider runAction:continuousBlink];
        
        for (int i = 0; i < 4; i++) {
            digits[i] = [CCSprite spriteWithFile:@"0.png"];
        }
        
        digits[0].position = ccp(80, 80);
        digits[1].position = ccp(170, 80);
        digits[2].position = ccp(270, 80);
        digits[3].position = ccp(360, 80);
    
        for (int i = 0; i < 4; i++) {
            [clockface addChild:digits[i]];
        }
        
        if (!hour24) {
            pmIndicator = [CCSprite spriteWithFile:@"AM.png"];
            pmIndicator.position = ccp(408, 125);
            pmIndicator.scale = 0.56;
            [clockface addChild:pmIndicator];
        }
        
        buttons = [NSMutableArray new];
        
        if (hourEnabled) {
            [self setupButtonXValue:125 yValue:190 valueToChange:1 changeHour:YES isUp:YES];
            [self setupButtonXValue:125 yValue:-40 valueToChange:1 changeHour:YES isUp:NO];
        }
        
        if (minuteEnabled) {
            [self setupButtonXValue:270 yValue:190 valueToChange:10 changeHour:NO isUp:YES];
            [self setupButtonXValue:360 yValue:190 valueToChange:1 changeHour:NO isUp:YES];
            [self setupButtonXValue:270 yValue:-40 valueToChange:10 changeHour:NO isUp:NO];
            [self setupButtonXValue:360 yValue:-40 valueToChange:1 changeHour:NO isUp:NO];
        }
    }
    return self;
}

-(void)setupButtonXValue:(int)xValue yValue:(int)yValue valueToChange:(int)toChange changeHour:(BOOL)changeHour isUp:(BOOL)isUp {
    CCSprite * buttonSprite;
    ClockButton * button = [ClockButton new];
    [button autorelease];
    if (isUp) {
        buttonSprite = [CCSprite spriteWithFile:@"Arrow_Up.png"];
    } else {
        buttonSprite = [CCSprite spriteWithFile:@"Arrow_Down.png"];
    }
    [button setSprite:buttonSprite];
    [button getSprite].position = ccp(xValue, yValue);
    button.valueToChange = toChange;
    button.changeHour = changeHour;
    button.isUp = isUp;
    button.clock = self;
    [clockface addChild:[button getSprite]];
    [buttons addObject:button];
}

-(void)processButtonClick:(ClockButton *)button {
    int multiplier = button.isUp ? 1 : -1;
    if (button.changeHour) {
        [time addHours:button.valueToChange * multiplier];
    } else {
        [time addMinutes:button.valueToChange * multiplier];
    }
    [self setTime:time];
    [linkedClock setTime:time];
}

-(void)setPosition:(CGPoint)position {
    clockface.position = position;
}

-(void)setTime:(Time *)timeToSet {
    time = timeToSet;
    int hours = timeToSet.hours;
    
    if (hour24) {
        hours = hours % 24;
        if (hours < 0) {
            hours = hours + 24;
        }
    } else {
        hours = hours % 24;
        if (hours <= 0) {
            hours += 24;
        }
        if (hours < 12) {
            [self setPmIndicator:NO];
        } else if (hours == 12) {
            [self setPmIndicator:YES];
        } else if (hours < 24) {
            [self setPmIndicator:YES];
            hours -= 12;
        } else {
            [self setPmIndicator:NO];
            hours = 12;
        }
    }
    int minutes = timeToSet.minutes;
    
    int firstDigit = hours / 10;
    if (firstDigit == 0) {
        [self setBlankDigit:1];
    } else {
        [self setDigit:1 with:firstDigit];
    }
    int secondDigit = hours % 10;
    [self setDigit:2 with:secondDigit];
    int thirdDigit = minutes / 10;
    [self setDigit:3 with:thirdDigit];
    int fourthDigit = minutes % 10;
    [self setDigit:4 with:fourthDigit];
    
}

-(void)setDigit:(int)position with:(int)digit {
    [digits[position - 1] setVisible:YES];
    NSString *filename = [NSString stringWithFormat:@"%d.png", digit];
    CCTexture2D * newDigit = [[CCTextureCache sharedTextureCache] addImage:filename];
    [digits[position - 1] setTexture:newDigit];
}

-(void)setBlankDigit:(int)position {
    [digits[position - 1] setVisible:NO];
}

-(void)setPmIndicator:(BOOL)pm {
    CCTexture2D * indicator;
    if (pm) {
        indicator = [[CCTextureCache sharedTextureCache] addImage:@"PM.png"];
    } else {
        indicator = [[CCTextureCache sharedTextureCache] addImage:@"AM.png"];
    }
    [pmIndicator setTexture:indicator];
}

-(ClockButton *)getButton:(int)index {
    return buttons[index];
}

-(NSArray *)getTouchableSprites {
    return buttons;
}

@end
