#import "Main.h"
#import <mach/mach_time.h>

#define RANDOM_SEED() srandom((unsigned)(mach_absolute_time() & 0xFFFFFFFF))

@interface Main(Private)
- (void)initClouds;
- (void)initCloud;
@end


@implementation Main

- (id)init {
//	NSLog(@"Main::init");
	
	if(![super init]) return nil;
	
	RANDOM_SEED();

	AtlasSpriteManager *spriteManager = [AtlasSpriteManager spriteManagerWithFile:@"sprites.png" capacity:10];
	[self addChild:spriteManager z:-1 tag:kSpriteManager];

	AtlasSprite *background = [AtlasSprite spriteWithRect:CGRectMake(0,0,320,480) spriteManager:spriteManager];
	[spriteManager addChild:background];
	background.position = CGPointMake(160,240);

	[self initClouds];

	[self schedule:@selector(step:)];
	
	return self;
}

- (void)dealloc {
//	NSLog(@"Main::dealloc");
	[super dealloc];
}

- (void)initClouds {
//	NSLog(@"initClouds");
	
	currentCloudTag = kCloudsStartTag;
	while(currentCloudTag < kCloudsStartTag + kNumClouds) {
		[self initCloud];
		currentCloudTag++;
	}
	
	[self resetClouds];
}

- (void)initCloud {
	
	CGRect rect;
	switch(random()%3) {
		case 0: rect = CGRectMake(336,16,256,108); break;
		case 1: rect = CGRectMake(336,128,257,110); break;
		case 2: rect = CGRectMake(336,240,252,119); break;
	}	
	
	AtlasSpriteManager *spriteManager = (AtlasSpriteManager*)[self getChildByTag:kSpriteManager];
	AtlasSprite *cloud = [AtlasSprite spriteWithRect:rect spriteManager:spriteManager];
	[spriteManager addChild:cloud z:3 tag:currentCloudTag];
	
	//cloud.opacity = 128;
}

- (void)resetClouds {
//	NSLog(@"resetClouds");
	
	currentCloudTag = kCloudsStartTag;
	
	while(currentCloudTag < kCloudsStartTag + kNumClouds) {
		[self resetCloud];

		AtlasSpriteManager *spriteManager = (AtlasSpriteManager*)[self getChildByTag:kSpriteManager];
		AtlasSprite *backgroundBees = (AtlasSprite*)[spriteManager getChildByTag:currentCloudTag];
		ccVertex2F pos = backgroundBees.position;
		pos.y -= 480.0f;
		backgroundBees.position = pos;
		
		currentCloudTag++;
	}
}

- (void)resetCloud {
	
	AtlasSpriteManager *spriteManager = (AtlasSpriteManager*)[self getChildByTag:kSpriteManager];
	AtlasSprite *backgroundBees = (AtlasSprite*)[spriteManager getChildByTag:currentCloudTag];
	
	float distance = random()%20 + 5;
	
	float scale = 5.0f / distance;
	backgroundBees.scaleX = scale;
	backgroundBees.scaleY = scale;
	//if(random()%2==1) backgroundBees.scaleX = -backgroundBees.scaleX;
	
	CGSize size = backgroundBees.contentSize;
	float scaled_width = size.width * scale;
	float x = random()%(320+(int)scaled_width) - scaled_width/2;
	float y = random()%(480-(int)scaled_width) + scaled_width/2 + 480;
	
	backgroundBees.position = ccp(x,y);
}

- (void)step:(ccTime)dt {
//	NSLog(@"Main::step");
	
	AtlasSpriteManager *spriteManager = (AtlasSpriteManager*)[self getChildByTag:kSpriteManager];
	//make stuff go down
	/*int t = kCloudsStartTag;
	for(t; t < kCloudsStartTag + kNumClouds; t++) {
		AtlasSprite *cloud = (AtlasSprite*)[spriteManager getChildByTag:t];
		CGPoint pos = cloud.position;
		CGSize size = cloud.contentSize;
		pos.x -= 1.1f * cloud.scaleY;
		if(pos.y <0 - size.height/2) {
			pos.x =+ 320+ size.height/2;
		}
		cloud.position = pos;*/
	int t = kCloudsStartTag;
	for(t; t < kCloudsStartTag + kNumClouds; t++) {
		AtlasSprite *backgroundBees = (AtlasSprite*)[spriteManager getChildByTag:t];
		CGPoint pos = backgroundBees.position;
		CGSize size = backgroundBees.contentSize;
		pos.x += 1.1f;
		if(pos.x > 320 + size.width/2) {
			pos.x = -size.width/2;
		}
		backgroundBees.position = pos;
	}
	
}

@end
