//
//  MenuLayer.m
//  Target Hit
//
//  Created by Christopher L Truman on 8/7/09.
//  Copyright 2009 Azusa Pacific University. All rights reserved.
//

#import "Instructions.h"
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
		CCSprite *back = [[CCSprite alloc] initWithFile:@"bearbeware_instructions.png"];
		self.background = back;
		[back release];
		
		background.anchorPoint = cpv(0, 0);
		
		[self addChild:background];
		
		CCMenuItem *backButton = [CCMenuItemImage itemFromNormalImage:@"back_button.png" selectedImage:@"back_button.png" target:self selector:@selector(back:)];
		backButton.scale = .5;
		menu = [CCMenu menuWithItems:backButton,  nil];
		[menu alignItemsVerticallyWithPadding:0.0];
		menu.position = ccp(160,15);
		
		[self addChild:menu];
	}
	
	return self;
}
- (void) back:(id) sender
{
	MenuScene *scene=[[MenuScene node] init];

    [[CCDirector sharedDirector] pushScene:[CCTransitionFade transitionWithDuration:.3 scene:scene]];
	}


@end
