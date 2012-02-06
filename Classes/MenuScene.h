//
//  MyScene.h
//  Target Hit
//
//  Created by Christopher L Truman on 8/7/09.
//  Copyright Azusa Pacific University 2009. All rights reserved.
//

#import "cocos2d.h"

@interface MenuLayer : CCLayer {
    CCMenu *menu;
	CCSprite *background;
}
@property (nonatomic, retain) CCMenu *menu;
@property (nonatomic, retain) CCSprite *background;


@end


@interface MenuScene : CCScene {
	MenuLayer *menuLayer;
}

@property (nonatomic, retain) MenuLayer *menuLayer;

@end

