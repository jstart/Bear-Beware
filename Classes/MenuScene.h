//
//  MyScene.h
//  Target Hit
//
//  Created by Christopher L Truman on 8/7/09.
//  Copyright Azusa Pacific University 2009. All rights reserved.
//

#import "cocos2d.h"
#import "Scene.h"

@interface MenuLayer : Layer {
    Menu *menu;
	Sprite *background;
    
}

@property (nonatomic, retain) Sprite *background;

@property (nonatomic, retain) Menu *menu;

@end


@interface MenuScene : Scene {
	MenuLayer *menuLayer;

}

@property (nonatomic, retain) MenuLayer *menuLayer;



@end

