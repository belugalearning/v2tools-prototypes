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
@implementation PinboardLayer {
    int circularNumberOfPins;
    BOOL circularIncludeCentre;
}

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
        
        pinboard = [SquarePinboard pinboard];
        [self setupPinboard];
        circularNumberOfPins = 10;
        circularIncludeCentre = NO;
        
        CCMenuItem * squarePinboardButton = [CCMenuItemImage itemWithNormalImage:@"squareLatticeButton.png" selectedImage:@"squareLatticeButton.png" target:self selector:@selector(squarePinboardTapped)];
        
        CCMenuItem * trianglePinboardButton = [CCMenuItemImage itemWithNormalImage:@"triangularLatticeButton.png" selectedImage:@"triangularLatticeButton.png" target:self selector:@selector(trianglePinboardTapped)];
        trianglePinboardButton.position = ccp(0, -110);
        
        CCMenuItem * circularPinboardButton = [CCMenuItemImage itemWithNormalImage:@"circularButton.png" selectedImage:@"circularButton.png" target:self selector:@selector(circularPinboardTapped)];
        circularPinboardButton.scaleX = 0.75;
        circularPinboardButton.position = ccp(-30, -220);
        
        CCMenuItem * centrePinToggle = [CCMenuItemImage itemWithNormalImage:@"centrePinButton.png" selectedImage:@"centrePinButton.png" target:self selector:@selector(centrePinToggleTapped)];
        centrePinToggle.position = ccp(85, -190);
        
        CCMenuItem * addPinButton = [CCMenuItemImage itemWithNormalImage:@"addPinButton.png" selectedImage:@"addPinButton.png" target:self selector:@selector(addPinButtonTapped)];
        addPinButton.position = ccp(85, -225);
        
        CCMenuItem * minusPinButton = [CCMenuItemImage itemWithNormalImage:@"minusPinButton.png" selectedImage:@"minusPinButton.png" target:self selector:@selector(minusPinButtonTapped)];
        minusPinButton .position = ccp(85, -260);
        
        CCMenu * pinboardTypesMenu = [CCMenu menuWithItems:
                                      squarePinboardButton,
                                      trianglePinboardButton,
                                      circularPinboardButton,
                                      centrePinToggle,
                                      addPinButton,
                                      minusPinButton, nil];
        pinboardTypesMenu.position = ccp(110, 500);
        [self addChild:pinboardTypesMenu];
        
        CCMenuItem * addBand = [CCMenuItemImage itemWithNormalImage:@"newBandButton.png" selectedImage:@"newBandButton.png" target:self selector:@selector(addBandTapped)];
        CCMenu * addBandMenu = [CCMenu menuWithItems:addBand, nil];
        addBandMenu.position = ccp(110, 100);
        [self addChild:addBandMenu];
        
        [[director touchDispatcher] addTargetedDelegate:self priority:0 swallowsTouches:YES];
	}
	return self;
}

-(void)setupPinboard {
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

-(void)squarePinboardTapped {
    if (![pinboard isKindOfClass:[SquarePinboard class]]) {
        [pinboard.background removeFromParentAndCleanup:YES];
        pinboard = [SquarePinboard pinboard];
        [self setupPinboard];
    }
}

-(void)trianglePinboardTapped {
    if (![pinboard isKindOfClass:[TrianglePinboard class]]) {
        [pinboard.background removeFromParentAndCleanup:YES];
        pinboard = [TrianglePinboard pinboard];
        [self setupPinboard];
    }
}

-(void)circularPinboardTapped {
    if (![pinboard isKindOfClass:[CircularPinboard class]]) {
        [pinboard.background removeFromParentAndCleanup:YES];
        pinboard = [CircularPinboard pinboardWithCentre:circularIncludeCentre pins:circularNumberOfPins];
        [self setupPinboard];
    }
}

-(void)centrePinToggleTapped {
    if ([pinboard isKindOfClass:[CircularPinboard class]]) {
        [pinboard.background removeFromParentAndCleanup:YES];
        circularIncludeCentre = !circularIncludeCentre;
        pinboard = [CircularPinboard pinboardWithCentre:circularIncludeCentre pins:circularNumberOfPins];
        [self setupPinboard];
    }
}

-(void)addPinButtonTapped {
    if ([pinboard isKindOfClass:[CircularPinboard class]]) {
        [pinboard.background removeFromParentAndCleanup:YES];
        circularNumberOfPins++;
        pinboard = [CircularPinboard pinboardWithCentre:circularIncludeCentre pins:circularNumberOfPins];
        [self setupPinboard];
    }
}

-(void)minusPinButtonTapped {
    if ([pinboard isKindOfClass:[CircularPinboard class]]) {
        if (circularNumberOfPins > 3) {
            [pinboard.background removeFromParentAndCleanup:YES];
            circularNumberOfPins = circularNumberOfPins - 1;
            pinboard = [CircularPinboard pinboardWithCentre:circularIncludeCentre pins:circularNumberOfPins];
            [self setupPinboard];
        }
    }
}

-(void)addBandTapped {
    [pinboard newBand];
}

#pragma mark GameKit delegate

@end
