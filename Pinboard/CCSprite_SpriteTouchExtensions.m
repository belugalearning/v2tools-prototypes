//
//  CCSprite_SpriteTouchExtensions.h
//  Pinboard
//
//  Created by Alex Jeffreys on 14/05/2013.
//
//

#import "CCSprite_SpriteTouchExtensions.h"

@implementation CCSprite (SpriteTouchExtensions)

-(BOOL)touched:(CGPoint)touch {
    CGPoint theTouch = [self.parent convertToNodeSpace:touch];
    return CGRectContainsPoint(self.boundingBox, theTouch);
}

@end