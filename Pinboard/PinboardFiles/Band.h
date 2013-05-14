//
//  Band.h
//  Pinboard
//
//  Created by Alex Jeffreys on 10/05/2013.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@class Pinboard;
@interface Band : NSObject {
    
}

@property (readwrite) NSMutableArray * pins;
@property (readwrite) NSMutableArray * bandParts;
@property (readwrite) Pinboard * pinboard;
@property (readwrite) ccColor3B colour;

-(void)drawBand;
-(id)initWithPinboard:(Pinboard *)pinboard andPins:(NSMutableArray *)pins;

@end
