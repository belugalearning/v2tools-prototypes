//
//  Pinboard.h
//  Pinboard
//
//  Created by Alex Jeffreys on 09/05/2013.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

typedef enum {
    square,
    triangular,
    circular_no_pin,
    circular_with_pin
} LatticeType;

@class Pin;
@interface Pinboard : NSObject {
}

@property (readwrite) NSMutableArray * pins;
@property (readwrite) CCSprite * background;

-(void)addToNode:(CCNode *)node;
-(void)setPosition:(CGPoint)position;
-(void)setupPins;
-(void)addPinsToBackground;
+(id)pinboard;

@end
