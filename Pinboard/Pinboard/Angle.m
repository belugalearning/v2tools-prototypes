//
//  Angle.m
//  Pinboard
//
//  Created by Alex Jeffreys on 20/05/2013.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import "Angle.h"


@implementation Angle {
    float red;
    float green;
    float blue;
}

@synthesize startAngle = startAngle_, throughAngle = throughAngle_, anticlockwise = anticlockwise_, label = label_, displaySameAngles = displaySameAngles_, numberOfArcs = numberOfArcs_;

-(void)draw {
    [super draw];
    glLineWidth(2);
        ccDrawColor4F(red/255, green/255, blue/255, 1);
    if (self.displaySameAngles) {
        for (int i = 1; i <= self.numberOfArcs; i++) {
            ccDrawArc(ccp(0, 0), 20 + 5*i, self.startAngle, self.throughAngle, 100, self.anticlockwise);
        }
    } else {
        ccDrawArc(ccp(0, 0), 30, self.startAngle, self.throughAngle, 100, self.anticlockwise);
        ccDrawColor4F(red/255, green/255, blue/255, 0.5);
        ccDrawSector(ccp(0, 0), 30, self.startAngle, self.throughAngle, 100, self.anticlockwise);
    }
}

-(void)setToDrawArcs:(int)numberOfArcs {
    self.displaySameAngles = YES;
    self.numberOfArcs = numberOfArcs;
}

-(void)setColourRed:(float)setRed green:(float)setGreen blue:(float)setBlue {
    red = setRed;
    green = setGreen;
    blue = setBlue;
}

@end
