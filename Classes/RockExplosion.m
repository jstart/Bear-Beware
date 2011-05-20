//
//  RockExplosion.m
//  GameDemo
//
//

#import "RockExplosion.h"
#import "TextureMgr.h"
#import "Director.h"
#import "Cocos2d.h"


@implementation RockExplosion
-(id) init
{
	return [self initWithTotalParticles:400];
}

-(id) initWithTotalParticles:(int)p
{
	if( !(self=[super initWithTotalParticles:p]) )
		return nil;
	
	// duration
	duration = 0.1f;
	
	// gravity
	gravity.x = 10;
	gravity.y = 10;
	
	// angle
	angle = 90;
	angleVar = 360;
	
	// speed of particles
	speed = 200;
	speedVar = 40;
	
	// radial
	radialAccel = 350;
	radialAccelVar = 350;
	
	// tagential
	tangentialAccel = 5;
	tangentialAccelVar = 5;
	
	// emitter position
	//position.x = 160;
	//position.y = 240;
	posVar.x = 0;
	posVar.y = 0;
	
	// life of particles
	life = 10.0f;
	lifeVar = 2;
	
	// size, in pixels
	startSize = 40.0f;
	startSizeVar = 20.0f;
	
	// emits per second
	emissionRate = totalParticles/duration;
	
	// color of particles
	startColor.r = 0.99f;
	startColor.g = 0.99f;
	startColor.b = 0.99f;
	startColor.a = 1.0f;
	startColorVar.r = 0.0f;
	startColorVar.g = 0.0f;
	startColorVar.b = 0.0f;
	startColorVar.a = 0.0f;
	endColor.r = 0.0f;
	endColor.g = 0.0f;
	endColor.b = 0.0f;
	endColor.a = 0.0f;
	endColorVar.r = 0.0f;
	endColorVar.g = 0.0f;
	endColorVar.b = 0.0f;
	endColorVar.a = 0.5f;
	
	self.texture = [[TextureMgr sharedTextureMgr] addImage: @"ball-1.png"];
	
	// additive
	blendAdditive = NO;
	
	return self;
}


@end
