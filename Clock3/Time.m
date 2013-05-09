//
//  Time.m
//  Clock3
//
//  Created by Alex Jeffreys on 01/05/2013.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import "Time.h"


@implementation Time

@synthesize hours, minutes, pm;

int hoursInDay = 24;
int minutesInHour = 60;


-(void)setTime:(int)hoursToSet minutes:(int)minutesToSet {
    
    if (minutesToSet < 0) {
        hoursToSet = hoursToSet + (minutesToSet + 1)/minutesInHour - 1;
        minutesToSet = minutesToSet + minutesInHour;
    } else {
        hoursToSet = hoursToSet + minutesToSet/minutesInHour;
        minutesToSet = minutesToSet % minutesInHour;
    }
    
    if (hoursToSet < 0) {
        hoursToSet = hoursToSet + hoursInDay;
    } else {
        hoursToSet = hoursToSet % hoursInDay;
    }
    
    if (hoursToSet >= 12) {
        pm = YES;
    } else {
        pm = NO;
    }
    
    hours = hoursToSet;
    minutes = minutesToSet;
}

-(void)changePm {
    pm = !pm;
}

-(void)addHours:(int)hoursToAdd {
    [self setTime:hours + hoursToAdd minutes:minutes];
}

-(void)addMinutes:(int)minutesToAdd {
    [self setTime:hours minutes:minutes + minutesToAdd];
}

+(Time *)randomTime {
    Time * randomTime = [Time new];
    int randomHours = arc4random_uniform(24);
    int randomMinutes = arc4random_uniform(60);
    [randomTime setTime:randomHours minutes:randomMinutes];
    return randomTime;
}

@end
