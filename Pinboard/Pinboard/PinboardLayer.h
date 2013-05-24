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
@class Band;
@class Pin;
@class BandPart;
@class BandSelectButton;
@interface PinboardLayer : CCLayer
{
    Pinboard * pinboard;
    CCDirector * director;
    CGSize size;
    
    Band * movingBand;
    NSArray * adjacentPins;
    Pin * movingPin;
}

@property (readwrite) CCSprite * border;

-(void)setRegularIndicatorWithRegular:(NSString *)regular;
-(void)setShapeIndicatorWith:(NSString *)shapeName;

// returns a CCScene that contains the PinboardLayer as the only child
+(CCScene *) scene;

@end
