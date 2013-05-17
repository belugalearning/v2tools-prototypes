//
//  HelloWorldLayer.m
//  Pinboard
//
//  Created by Alex Jeffreys on 09/05/2013.
//  Copyright __MyCompanyName__ 2013. All rights reserved.
//


// Import the interfaces
#import "PinboardLayer.h"
#import "Pinboard.h"
#import "SquarePinboard.h"
#import "TrianglePinboard.h"
#import "CircularPinboard.h"
#import "Pin.h"
#import "Band.h"
#import "BandPart.h"
#import "CCSprite_SpriteTouchExtensions.h"

// Needed to obtain the Navigation Controller
#import "AppDelegate.h"

#pragma mark - HelloWorldLayer

// HelloWorldLayer implementation
@implementation PinboardLayer

// Helper class method that creates a Scene with the HelloWorldLayer as the only child.
+(CCScene *) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	PinboardLayer *layer = [PinboardLayer node];
	
	// add layer as a child to scene
	[scene addChild: layer];
	
	// return the scene
	return scene;
}

// on "init" you need to initialize your instance
-(id) init
{
	// always call "super" init
	// Apple recommends to re-assign "self" with the "super's" return value
	if( (self=[super init]) ) {
        
        director = [CCDirector sharedDirector];
		size = [director winSize];
        
        [self setupPinboard];
         
        Pin * firstPin = [pinboard.pins objectAtIndex:1];
        Pin * secondPin = [pinboard.pins objectAtIndex:2];
        Pin * thirdPin = [pinboard.pins objectAtIndex:3];
        Pin * fourthPin = [pinboard.pins objectAtIndex:4];
        //Pin * fifthPin = [pinboard.pins objectAtIndex:5];
        //Pin * sixthPin = [pinboard.pins objectAtIndex:6];
        NSMutableArray * pins = [NSMutableArray arrayWithObjects:firstPin, secondPin, thirdPin, fourthPin, nil];
        Band * band = [Band bandWithPinboard:pinboard andPins:pins];
        [band setupBand];
        
        

        
        
        
        [[director touchDispatcher] addTargetedDelegate:self priority:0 swallowsTouches:YES];
	}
	return self;
}

-(void)setupPinboard {
    pinboard = [CircularPinboard pinboard];
    [pinboard setPosition:ccp(size.width/2, size.height/2)];
    [pinboard addToNode:self];
}

-(BOOL)ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event {
    CGPoint touchLocation = [self convertTouchToNodeSpace:touch];
    [pinboard processTouch:touchLocation];
    
    return YES;
}


-(void)ccTouchMoved:(UITouch *)touch withEvent:(UIEvent *)event {
    CGPoint touchLocation = [self convertTouchToNodeSpace:touch];
    [pinboard processMove:touchLocation];
}

-(void)ccTouchEnded:(UITouch *)touch withEvent:(UIEvent *)event {
    CGPoint touchLocation = [self convertTouchToNodeSpace:touch];
    [pinboard processEnd:touchLocation];
}

#pragma mark GameKit delegate

@end
