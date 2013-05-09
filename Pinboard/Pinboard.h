//
//  Pinboard.h
//  Pinboard
//
//  Created by Alex Jeffreys on 09/05/2013.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

typedef enum {
    square,
    triangular,
    circular_no_pin,
    circular_with_pin
} LatticeType;

@interface Pinboard : NSObject {
    CCSprite * background;
    LatticeType * latticeType;
}

@end

@interface RegularPinboard : Pinboard

@end

@interface SquarePinboard : RegularPinboard

@end

@interface TrianglePinboard : RegularPinboard

@end

@interface CircularPinboard : Pinboard

@end
