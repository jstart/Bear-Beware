//
//  MenuLayer.h
//  Target Hit
//
//  Created by Christopher L Truman on 8/7/09.
//  Copyright 2009 Azusa Pacific University. All rights reserved.
//

#import "cocos2d.h"


@interface Instructions : Layer {
Menu *menu;
	Sprite *background;

}

@property (nonatomic, retain) Sprite *background;

@property (nonatomic, retain) Menu *menu;

@end
