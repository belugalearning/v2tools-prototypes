//
//  RegularPinboard.h
//  Pinboard
//
//  Created by Alex Jeffreys on 09/05/2013.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "Pinboard.h"

@interface RegularPinboard : Pinboard {

}

@property (readonly) int distanceBetweenPins;
@property (readwrite) float angleBetweenAxes;

@end
