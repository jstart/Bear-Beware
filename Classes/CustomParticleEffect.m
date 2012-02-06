//
//  RockExplosion.m
//  GameDemo
//
//

#import "CustomParticleEffect.h"
#import "CCTextureCache.h"
#import "Cocos2d.h"


@implementation CustomParticleEffect
-(id) init
{
	return [self initWithTotalParticles:400];
}

-(id) initWithTotalParticles:(NSUInteger)p
{
	if( !(self=[super initWithTotalParticles:p]) )
		return nil;
	
	// duration
	duration = 0.1f;

	// angle
	angle = 90;
	angleVar = 360;
	
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
	
	self.texture = [[CCTextureCache sharedTextureCache] addImage:@"ball-1.png"];
	
	return self;
}


@end
