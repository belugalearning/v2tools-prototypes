//
//  HelloWorldLayer.h
//  Pinboard
//
//  Created by Alex Jeffreys on 09/05/2013.
//  Copyright __MyCompanyName__ 2013. All rights reserved.
//


#import <GameKit/GameKit.h>

// When you import this file, you import all the cocos2d classes
#import "cocos2d.h"

@class Pinboard;
@interface PinboardLayer : CCLayer
{
    Pinboard * pinboard;
    
    CCDirector * director;
    CGSize size;
}

// returns a CCScene that contains the PinboardLayer as the only child
+(CCScene *) scene;

@end
