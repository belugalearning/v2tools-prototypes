//
//  HelloWorldLayer.m
//  Clock3
//
//  Created by Alex Jeffreys on 26/04/2013.
//  Copyright __MyCompanyName__ 2013. All rights reserved.
//


// Import the interfaces
#import "HelloWorldLayer.h"
#import "DigitalClock.h"
#import "Time.h"
#import "TouchableSprite.h"

// Needed to obtain the Navigation Controller
#import "AppDelegate.h"

#pragma mark - HelloWorldLayer

// HelloWorldLayer implementation
@implementation HelloWorldLayer

// Helper class method that creates a Scene with the HelloWorldLayer as the only child.
+(CCScene *) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	HelloWorldLayer *layer = [HelloWorldLayer node];
	
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
        
        // Settings
        
        clocksIndependent = NO;
        bothStartFromRandom = YES;
        initialBothTime = [Time new];
        [initialBothTime setTime:6 minutes:0];
        
        clock1Type = analogue;
        clock1hour24 = NO;
        clock1HourEnabled = YES;
        clock1MinuteEnabled = YES;
        clock1StartFromRandom = YES;
        initialClock1Time = [Time new];
        [initialClock1Time setTime:0 minutes:0];
        
        clock2Type = digital;
        clock2hour24 = YES;
        clock2HourEnabled = YES;
        clock2MinuteEnabled = YES;
        clock2StartFromRandom = YES;
        initialClock2Time = [Time new];
        [initialClock2Time setTime:0 minutes:0];
        
        clockfaceType = main_numbers;
        
        //End of settings
        
        
        CCDirector *director = [CCDirector sharedDirector];
		CGSize size = [director winSize];
        
        Clock * clock1;
        Clock * clock2;
        
        int numberOfClocks = 2;
        
        if (clock1Type == analogue) {
            clock1 = [self setupAnalogueClock:YES];
        } else if (clock1Type == digital) {
            clock1 = [self setupDigitalClock:YES];
        } else {
            clock1 = nil;
            numberOfClocks -= 1;
        }
        
        if (clock2Type == analogue) {
            clock2 = [self setupAnalogueClock:NO];
        } else if (clock2Type == digital) {
            clock2 = [self setupDigitalClock:NO];
        } else {
            clock2 = nil;
            numberOfClocks -= 1;
        }
        
        if (numberOfClocks == 1 && clock1 == nil) {
            clock1 = clock2;
        }
        
        if (numberOfClocks == 2) {
            [clock1 setPosition:ccp(size.width * 1/4, size.height * 1/2)];
            [clock2 setPosition:ccp(size.width * 3/4, size.height * 1/2)];
        } else if (numberOfClocks == 1) {
            [clock1 setPosition:ccp(size.width * 1/2, size.height * 1/2)];
        }
        
        if (numberOfClocks == 2 && !clocksIndependent) {
            clock1.linkedClock = clock2;
            clock2.linkedClock = clock1;
            
            if (bothStartFromRandom) {
                [initialBothTime release];
                initialBothTime = [Time randomTime];
            }
            [clock1 setTime:initialBothTime];
            [clock2 setTime:initialBothTime];
        } else {
            if (clock1StartFromRandom) {
                [initialClock1Time release];
                initialClock1Time = [Time randomTime];
            }
            [clock1 setTime:initialClock1Time];
            
            if (numberOfClocks == 2) {
                if (clock2StartFromRandom) {
                    [initialClock2Time release];
                    initialClock2Time = [Time randomTime];
                }
                [clock2 setTime:initialClock2Time];
            }
        }
        
        if ([clock1 isKindOfClass:[AnalogueClock class]]) {
            clock1 = (AnalogueClock *)clock1;
        }
        
        touchableSprites = [NSMutableArray new];
        [touchableSprites addObjectsFromArray:[clock1 getTouchableSprites]];
        if (numberOfClocks == 2) {
                [touchableSprites addObjectsFromArray:[clock2 getTouchableSprites]];
        }
        
        [[director touchDispatcher] addTargetedDelegate:self priority:0 swallowsTouches:YES];

	}
	return self;
}

-(AnalogueClock *)setupAnalogueClock:(BOOL)firstClock {
    BOOL hoursEnabled = firstClock ? clock1HourEnabled : clock2HourEnabled;
    BOOL minutesEnabled = firstClock ? clock1MinuteEnabled : clock2MinuteEnabled;
    AnalogueClock * clock = [[AnalogueClock alloc] initWithHourHandEnabled:hoursEnabled andMinuteHandEnabled:minutesEnabled andClockFaceType:clockfaceType];
    [clock autorelease];
    [clock addToNode:self];
    [clock setScale:0.5];
    return clock;
}

-(DigitalClock *)setupDigitalClock:(BOOL)firstClock {
    BOOL hoursEnabled = firstClock ? clock1HourEnabled : clock2HourEnabled;
    BOOL minutesEnabled = firstClock ? clock1MinuteEnabled : clock2MinuteEnabled;
    BOOL hour24 = firstClock ? clock1hour24 : clock2hour24;
    DigitalClock * clock = [[DigitalClock alloc] initWithHour:hour24 andHourButtonsEnabled:hoursEnabled andMinuteButtonsEnabled:minutesEnabled];
    [clock autorelease];
    [clock addToNode:self];
    [clock setScale:0.5];
    clock.hour24 = hour24;
    return clock;
}

-(BOOL)ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event {
    CGPoint touchLocation = [self convertTouchToNodeSpace:touch];
    
    for (TouchableSprite * touchableSprite in touchableSprites) {
        if ([touchableSprite isTouching:touchLocation]) {
            selectedSprite = touchableSprite;
            break;
        }
    }
    
    if (selectedSprite) {
        [selectedSprite processTouch];
        [self performSelector:@selector(repeatProcessTouch) withObject:nil afterDelay:1];
    }
    return TRUE;
}

-(void)repeatProcessTouch {
    repeatTouch = [NSTimer scheduledTimerWithTimeInterval:0.1 target:selectedSprite selector:@selector(processTouch) userInfo:nil repeats:YES];
}

-(void)ccTouchMoved:(UITouch *)touch withEvent:(UIEvent *)event {
    CGPoint point = [touch locationInView:[touch view]];
    point = [[CCDirector sharedDirector] convertToGL:point];
    if (selectedSprite) {
        [selectedSprite processMove:point];
    }
}

-(void)ccTouchEnded:(UITouch *)touch withEvent:(UIEvent *)event {
    selectedSprite = nil;
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(repeatProcessTouch) object:nil];
    [repeatTouch invalidate];
    repeatTouch = nil;
}

// on "dealloc" you need to release all your retained objects
- (void) dealloc
{	
	// don't forget to call "super dealloc"
	[super dealloc];
}

#pragma mark GameKit delegate

-(void) achievementViewControllerDidFinish:(GKAchievementViewController *)viewController
{
	AppController *app = (AppController*) [[UIApplication sharedApplication] delegate];
	[[app navController] dismissModalViewControllerAnimated:YES];
}

-(void) leaderboardViewControllerDidFinish:(GKLeaderboardViewController *)viewController
{
	AppController *app = (AppController*) [[UIApplication sharedApplication] delegate];
	[[app navController] dismissModalViewControllerAnimated:YES];
}
@end
