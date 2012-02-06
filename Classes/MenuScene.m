//
//  MenuScene.m
//  Target Hit
//
//  Created by Christopher L Truman on 8/7/09.
//  Copyright Azusa Pacific University 2009. All rights reserved.
//

#import "MenuScene.h"
#import "cocos2d.h"

@interface MenuScene (Private)

@end

@implementation MenuScene

@synthesize menuLayer;

- (void) dealloc
{
	//[menuLayer release];
	[super dealloc];
}

- (id) init
{
	self = [super init];
	
	if (self)
	{	
		MenuLayer *layer = [[MenuLayer alloc] init];
		self.menuLayer = layer;
		[layer release];
		
		[self addChild:menuLayer];
	}
	
	return self;
}

@end

#import "chipmunk.h"
#import "Game.h"
#import "Instructions.h"
#import "Highscores.h"

@implementation MenuLayer

@synthesize background, menu;


- (void) dealloc
{
	[background release];
    
	[super dealloc];
}

-(id) init
{
	self = [super init];
	
	if (self)
	{
		Sprite *back = [[Sprite alloc] initWithFile:@"bearbeware_menu.png"];
		self.background = back;
		[back release];
		
		background.anchorPoint = cpv(0, 0);
		
		[self addChild:background];
		
		MenuItem *play = [MenuItemImage itemFromNormalImage:@"play_button.png" selectedImage:@"play_button.png" target:self selector:@selector(play:)];
		MenuItem *about = [MenuItemImage itemFromNormalImage:@"instructions_button.png" selectedImage:@"instructions_button.png" target:self selector:@selector(instructions:)];
		MenuItem *scores = [MenuItemImage itemFromNormalImage:@"scores_button.png" selectedImage:@"scores_button.png" target:self selector:@selector(scores:)];
		/*ParticleSystem* p = [ParticleFlower node];
         //p.size = 10;
         p.totalParticles = 400;
         p.position = play.transformAnchor;
         [play addChild:p];*/
		menu = [Menu menuWithItems:play, about, scores,nil]; //scores,  nil];
        [menu alignItemsVerticallyWithPadding:10.0];
        [self addChild:menu];
	}
	
	return self;
}
- (void) play:(id) sender
{
	Scene *scene = [[Scene node] addChild:[Game node] z:0];
	
    [[Director sharedDirector] replaceScene:[FadeTransition transitionWithDuration:.3 scene:scene]];
}
- (void) instructions:(id) sender
{
	Scene *scene = [[Scene node] addChild:[Instructions node] z:0];
	
    [[Director sharedDirector] replaceScene:[FadeTransition transitionWithDuration:.3 scene:scene]];}

- (void) scores:(id) sender
{
	[[NSNotificationCenter defaultCenter] postNotificationName:@"moreGames" object:@""];
}

@end
