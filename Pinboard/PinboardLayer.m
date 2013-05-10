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
        
        
	}
	return self;
}

-(void)setupPinboard {
    pinboard = [CircularPinboard pinboard];
    [pinboard setPosition:ccp(size.width/2, size.height/2)];
    [pinboard addToNode:self];
}

#pragma mark GameKit delegate

@end
