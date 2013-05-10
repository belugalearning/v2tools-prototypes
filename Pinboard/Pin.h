//
//  MyCocos2DClass.h
//  Pinboard
//
//  Created by Alex Jeffreys on 09/05/2013.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface Pin : NSObject {

}

@property (readwrite) CCSprite * sprite;
@property (readwrite) int x;
@property (readwrite) int y;
@property (readwrite) int circleIndex;
@property (readwrite) BOOL colour;

-(void)addToNode:(CCNode *)node;
-(void)setPosition:(CGPoint)point;
+(id)pin;
+(id)pinWithX:(int)x andY:(int)y;
+(id)pinWithCircleIndex:(int)index;

@end
