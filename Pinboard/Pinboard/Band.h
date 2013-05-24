//
//  Band.h
//  Pinboard
//
//  Created by Alex Jeffreys on 10/05/2013.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@class Pinboard;
@class Pin;
@class Band;
@class BandPart;
@interface Band : NSObject {
    
}

@property (readwrite) NSMutableArray * pins;
@property (readwrite) NSMutableArray * bandParts;
@property (readwrite) Pinboard * pinboard;
@property (readwrite) ccColor3B colour;
@property (readwrite) CCNode * bandNode;
@property (readwrite) NSMutableArray * angles;
@property (readwrite) BOOL anticlockwise;
@property (readwrite) CCNode * propertiesNode;
@property (readwrite) NSMutableArray * sideLengths;
@property (readwrite) NSString * sideDisplay;
@property (readwrite) NSMutableArray * sameSideLengthNotches;
@property (readwrite) NSMutableArray * parallelSideArrows;

-(id)initWithPinboard:(Pinboard *)pinboard andPins:(NSMutableArray *)pins;
+(id)bandWithPinboard:(Pinboard *)pinboard andPins:(NSMutableArray *)pins;
-(void)processTouch:(CGPoint)touchLocation;
-(void)processMove:(CGPoint)touchLocation;
-(void)processEnd:(CGPoint)touchLocation;
-(void)pinBandOnPin:(Pin *)pin;
-(void)setupBand;
-(void)removeMovingPin;
-(void)showAngles;
-(NSString *)regular;
-(NSString *)shape;
-(void)displaySides;
-(void)toggleSideDisplay:(NSString *)sideDisplay;
-(void)clearSameSideLengthNotches;
-(void)clearParallelSideArrows;

@end
