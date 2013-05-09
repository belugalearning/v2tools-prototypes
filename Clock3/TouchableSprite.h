//
//  TouchableSprite.h
//  Clock3
//
//  Created by Alex Jeffreys on 02/05/2013.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface TouchableSprite : NSObject {
    CCSprite * sprite;
}

-(BOOL)isTouching:(CGPoint)touchLocation;
-(void)processTouch;
-(void)processMove:(CGPoint)touchLocation;
-(CCSprite *)getSprite;
-(void)setSprite:(CCSprite *)spriteToSet;

@end
