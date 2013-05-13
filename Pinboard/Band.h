//
//  Band.h
//  Pinboard
//
//  Created by Alex Jeffreys on 10/05/2013.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface Band : NSObject {
    
}

@property (readwrite) NSMutableArray * pins;

-(void)drawBand;

@end
