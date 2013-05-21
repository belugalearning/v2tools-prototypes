//
//  Angle.h
//  Pinboard
//
//  Created by Alex Jeffreys on 20/05/2013.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface Angle : CCNode {
    
}

@property (readwrite) float startAngle;
@property (readwrite) float throughAngle;
@property (readwrite) BOOL anticlockwise;
@property (readwrite) CCLabelTTF * label;

-(void)setColourRed:(float)setRed green:(float)setGreen blue:(float)setBlue;

@end
