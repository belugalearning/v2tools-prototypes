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
@class Band;
@class PinboardLayer;
@interface Pinboard : NSObject {
}

@property (readwrite) NSMutableArray * pins;
@property (readwrite) CCSprite * background;
@property (readwrite) NSMutableArray * bands;
@property (readwrite) PinboardLayer * layer;

-(void)addToNode:(CCNode *)node;
-(void)setPosition:(CGPoint)position;
-(void)setupPins;
-(void)addPinsToBackground;
+(id)pinboard;
-(void)addBand:(Band *)band;
-(void)processTouch:(CGPoint)touchLocation;
-(void)processMove:(CGPoint)touchLocation;
-(void)processEnd:(CGPoint)touchLocation;
-(void)setMovingBand:(Band *)band;
-(Band *)newBand;
-(void)showAngles;
-(void)setCurrentBandSideDisplay:(NSString *)sideDisplay;
-(float)unitDistance;
-(void)recalculateSameSideLengths;

@end
