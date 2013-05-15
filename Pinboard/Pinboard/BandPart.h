//
//  BandPart.h
//  Pinboard
//
//  Created by Alex Jeffreys on 14/05/2013.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@class Pin;
@class Band;
@interface BandPart : NSObject {
    
}

@property (readwrite) CCNode * baseNode;
@property (readwrite) CCSprite * sprite;
@property (readwrite) Pin * fromPin;
@property (readwrite) Pin * toPin;
@property (readwrite) Band * band;

-(id)initWithBand:(Band *)band fromPin:(Pin *)fromPin toPin:(Pin *)toPin;
-(void)setToBeFromPin:(Pin *)fromPin toPin:(Pin *)toPin;
+(id)bandPartWithBand:(Band *)band fromPin:(Pin *)fromPin toPin:(Pin *)toPin;
-(NSArray *)adjacentPins;
-(void)setPositionAndRotation;

@end
