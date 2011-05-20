//
//  MenuLayer.m
//  Target Hit
//
//  Created by Christopher L Truman on 8/7/09.
//  Copyright 2009 Azusa Pacific University. All rights reserved.
//

#import "Instructions.h"
#import "MenuLayer.h"
#import "MenuScene.h"
#import "chipmunk.h"
@implementation Instructions

@synthesize background, menu;


- (void) dealloc
{
	[background release];
	[menu release];
	[super dealloc];
}

-(id) init
{
	self = [super init];
	
	if (self)
	{
		Sprite *back = [[Sprite alloc] initWithFile:@"bearbeware_instructions.png"];
		self.background = back;
		[back release];
		
		background.anchorPoint = cpv(0, 0);
		
		[self addChild:background];
		
		MenuItem *backButton = [MenuItemImage itemFromNormalImage:@"back_button.png" selectedImage:@"back_button.png" target:self selector:@selector(back:)];
		backButton.scale = .5;
		menu = [Menu menuWithItems:backButton,  nil];
		[menu alignItemsVerticallyWithPadding:0.0];
		menu.position = ccp(160,15);
		
		[self addChild:menu];
	}
	
	return self;
}
- (void) back:(id) sender
{
	MenuScene *scene=[[MenuScene node] init];
	//Scene *scene = [[Scene node] addChild:[MenuLayer node] z:0];

    [[Director sharedDirector] pushScene:[FadeTransition transitionWithDuration:.3 scene:scene]];
	}


@end
