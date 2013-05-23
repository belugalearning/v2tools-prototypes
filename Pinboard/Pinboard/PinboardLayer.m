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
    CCMenu * bandSelectMenu;
    CCLayer * layer;
    CCLabelTTF * regularIndicatorLabel;
    CCLabelTTF * shapeIndicatorLabel;
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
        
        bandSelectMenu = [CCMenu new];
        bandSelectMenu.position = ccp(800, 700);
        [self addChild:bandSelectMenu];
        
        CCNode * propertiesIndicator = [CCNode node];
        propertiesIndicator.position = ccp(900, 500);
        [self addChild:propertiesIndicator];
        
        CCSprite * regularIndicator = [CCSprite spriteWithFile:@"propertyBackground.png"];
        regularIndicatorLabel = [CCLabelTTF labelWithString:@"" fontName:@"Arial" fontSize:24];
        regularIndicatorLabel.color = ccc3(0, 0, 0);
        regularIndicatorLabel.position = ccp(regularIndicator.contentSize.width * regularIndicator.scaleX/2, regularIndicator.contentSize.height * regularIndicator.scaleY/2);
        [regularIndicator addChild:regularIndicatorLabel];
        [propertiesIndicator addChild:regularIndicator];
        
        CCSprite * shapeIndicator = [CCSprite spriteWithFile:@"propertyBackground.png"];
        shapeIndicatorLabel = [CCLabelTTF labelWithString:@"" fontName:@"Arial" fontSize:24];
        shapeIndicatorLabel.color = ccc3(0, 0, 0);
        shapeIndicatorLabel.position = ccp(shapeIndicator.contentSize.width * shapeIndicator.scaleX/2, shapeIndicator.contentSize.height * shapeIndicator.scaleY/2);
        shapeIndicator.position = ccp(0, -80);
        [shapeIndicator addChild:shapeIndicatorLabel];
        [propertiesIndicator addChild:shapeIndicator];
        
        
        CCMenuItem * showAnglesButton = [CCMenuItemImage itemWithNormalImage:@"showAnglesButton.png" selectedImage:@"showAnglesButton.png" target:self selector:@selector(showAnglesButtonTapped)];
        CCMenuItem * showSideLengthsButton = [CCMenuItemImage itemWithNormalImage:@"showSideLengthsButton.png" selectedImage:@"showSideLengthsButton.png" target:self selector:@selector(showSideLengthsButtonTapped)];
        showSideLengthsButton.position = ccp(0, -80);
        CCMenuItem * showSameSideLengthButton = [CCMenuItemImage itemWithNormalImage:@"sameSideLengthButton.png" selectedImage:@"sameSideLengthButton.png" target:self selector:@selector(showSameSideLengthButtonTapped)];
        showSameSideLengthButton.position = ccp(0, -160);
        CCMenu * bandPropertiesMenu = [CCMenu menuWithItems:showAnglesButton, showSideLengthsButton, showSameSideLengthButton, nil];
        bandPropertiesMenu.position = ccp(900, 300);
        [self addChild:bandPropertiesMenu];
        
        /*
        Pin * firstPin = [pinboard.pins objectAtIndex:3];
        Pin * secondPin = [pinboard.pins objectAtIndex:24];
        Pin * thirdPin = [pinboard.pins objectAtIndex:56];
        Pin * fourthPin = [pinboard.pins objectAtIndex:89];
        NSMutableArray * array = [NSMutableArray arrayWithObjects:firstPin, secondPin, thirdPin, fourthPin, nil];
        Band * band = [Band bandWithPinboard:pinboard andPins:array];
        [band setupBand];
         */
        

        [[director touchDispatcher] addTargetedDelegate:self priority:0 swallowsTouches:YES];
	}
	return self;
}

-(void)setupPinboard {
    [self clearIndicators];
    [pinboard setPosition:ccp(size.width/2, size.height/2)];
    [pinboard addToNode:self];
    pinboard.layer = self;
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
        [self clearPinboardSprites];
        pinboard = [SquarePinboard pinboard];
        [self setupPinboard];
    }
}

-(void)trianglePinboardTapped {
    if (![pinboard isKindOfClass:[TrianglePinboard class]]) {
        [self clearPinboardSprites];
        pinboard = [TrianglePinboard pinboard];
        [self setupPinboard];
    }
}

-(void)circularPinboardTapped {
    if (![pinboard isKindOfClass:[CircularPinboard class]]) {
        [self clearPinboardSprites];
        pinboard = [CircularPinboard pinboardWithCentre:circularIncludeCentre pins:circularNumberOfPins];
        [self setupPinboard];
    }
}

-(void)centrePinToggleTapped {
    if ([pinboard isKindOfClass:[CircularPinboard class]]) {
        [self clearPinboardSprites];
        circularIncludeCentre = !circularIncludeCentre;
        pinboard = [CircularPinboard pinboardWithCentre:circularIncludeCentre pins:circularNumberOfPins];
        [self setupPinboard];
    }
}

-(void)addPinButtonTapped {
    if ([pinboard isKindOfClass:[CircularPinboard class]]) {
        [self clearPinboardSprites];
        circularNumberOfPins++;
        pinboard = [CircularPinboard pinboardWithCentre:circularIncludeCentre pins:circularNumberOfPins];
        [self setupPinboard];
    }
}

-(void)minusPinButtonTapped {
    if ([pinboard isKindOfClass:[CircularPinboard class]]) {
        if (circularNumberOfPins > 3) {
        [self clearPinboardSprites];
            circularNumberOfPins = circularNumberOfPins - 1;
            pinboard = [CircularPinboard pinboardWithCentre:circularIncludeCentre pins:circularNumberOfPins];
            [self setupPinboard];
        }
    }
}

-(void)clearPinboardSprites {
    [pinboard.background removeFromParentAndCleanup:YES];
    [bandSelectMenu removeAllChildrenWithCleanup:YES];
}

-(void)addBandTapped {
    if ([pinboard.bands count] < 24) {
        Band * newBand = [pinboard newBand];
        CCMenuItemImage * bandSelectButtonImage = [CCMenuItemImage itemWithNormalImage:@"bandButton.png" selectedImage:@"bandButton.png" target:pinboard selector:@selector(selectBandFromButton:)];
        bandSelectButtonImage.userObject = newBand;
        bandSelectButtonImage.color = newBand.colour;
        [self addBandSelectButton:bandSelectButtonImage];
    }
}

-(void)addBandSelectButton:(CCMenuItem *)newButton {
    int numberOfButtons = [bandSelectMenu.children count];
    int numberOfRows = 6;
    int xPosition = 0 + 30 * (numberOfButtons%numberOfRows);
    int yPosition = 0 - 30 * (numberOfButtons/numberOfRows);
    newButton.position = ccp(xPosition, yPosition);
    [bandSelectMenu addChild:newButton];
}

-(void)showAnglesButtonTapped {
    [pinboard showAngles];
}

-(void)showSideLengthsButtonTapped {
    [pinboard setCurrentBandSideDisplay:@"sideLengths"];
}

-(void)showSameSideLengthButtonTapped {
    [pinboard setCurrentBandSideDisplay:@"sameSideLengths"];
}

-(void)setRegularIndicatorWithRegular:(NSString *)regular {
    [regularIndicatorLabel setString:regular];
}

-(void)setShapeIndicatorWith:(NSString *)shapeName {
    [shapeIndicatorLabel setString:shapeName];
}

-(void)clearIndicators {
    [regularIndicatorLabel setString:@""];
    [shapeIndicatorLabel setString:@""];
}

#pragma mark GameKit delegate

@end
