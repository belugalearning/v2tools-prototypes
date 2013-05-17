//
//  CircularPinboard.h
//  Pinboard
//
//  Created by Alex Jeffreys on 09/05/2013.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "Pinboard.h"

@interface CircularPinboard : Pinboard {
    
}

@property (readwrite) float radius;
@property (readwrite) int numberOfPins;
@property (readwrite) BOOL includeCentre;

-(id)initWithCentre:(BOOL)includeCentre pins:(int)numberOfPins;
+(id)pinboardWithCentre:(BOOL)includeCentre pins:(int)numberOfPins;

@end
