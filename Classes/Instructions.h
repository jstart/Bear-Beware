//
//  MenuLayer.h
//  Target Hit
//
//  Created by Christopher L Truman on 8/7/09.
//  Copyright 2009 Azusa Pacific University. All rights reserved.
//

#import "cocos2d.h"


@interface Instructions : CCLayer {
    CCMenu *menu;
	CCSprite *background;
}
@property (nonatomic, retain) CCMenu *menu;
@property (nonatomic, retain) CCSprite *background;

@end
