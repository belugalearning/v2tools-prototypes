//
//  Time.h
//  Clock3
//
//  Created by Alex Jeffreys on 01/05/2013.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface Time : NSObject {
    int hours;
    int minutes;
    BOOL pm;
}

@property (readonly) int hours;
@property (readonly) int minutes;
@property (readonly) BOOL pm;

-(void)setTime:(int)hoursToSet minutes:(int)minutesToSet;
-(void)addHours:(int)hoursToAdd;
-(void)addMinutes:(int)minutesToAdd;
-(void)changePm;
+(Time *)randomTime;

@end
