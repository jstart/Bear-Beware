//
//  MenuScene.m
//  Target Hit
//
//  Created by Christopher L Truman on 8/7/09.
//  Copyright Azusa Pacific University 2009. All rights reserved.
//

#import "MenuScene.h"
#import "cocos2d.h"
#import "MenuLayer.h"
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
