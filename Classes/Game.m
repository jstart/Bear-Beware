#import "Game.h"
#import "Main.h"
#import "Highscores.h"
#import "chipmunk.h"
#import "RockExplosion.h"


#import "Target.h"
#include <AudioToolbox/AudioToolbox.h>

@interface Game (Private)
- (void)startGame;
-(void) setupSound;
- (void)setupCollisionHandlers;
- (void)step:(ccTime)dt;
- (void)showHighscores;
-(void) createExplosionX: (float) x y: (float) y;
-(cpBody *) makeBirdX: (float) x y:(float) y;
-(cpBody *) addSpriteNamed: (NSString *)name x: (float)x y:(float)y type:(unsigned int) type;
-(void) updateTargets;
-(void) checkForGameOver;
@end


@implementation Game
@synthesize targets, pots,bonus, b, speedUp, speedDown, life, hit, catch, catchSpeedUp, catchSpeedDown, catchLife, catchShield, messageLabel;
@synthesize slurpSound;
@synthesize slurpSoundObject;
@synthesize hitSound;
@synthesize hitSoundObject;
@synthesize gameOverSound;
@synthesize gameOverSoundObject;
@synthesize _player;
@synthesize dataManager;

// collision types
enum {
	kColl_Bear,
	kColl_Bee,
	kColl_Pot,
	kColl_SpeedUp,
	kColl_SpeedDown,
	kColl_Life,
	kColl_Shield
};

- (id)init {
	NSLog(@"Game::init");
	if(![super init]) return nil;
	lives=3;
	speedModifier=0;
	gameSuspended = YES;
	hit=NO;
	catch=NO;
	catchSpeedUp=NO;
	catchSpeedDown=NO;
	catchLife=NO;
	catchShield=NO;
	reachedScore=NO;
	
	self.dataManager = [DataManager sharedManager];
	
	AtlasSpriteManager *spriteManager = (AtlasSpriteManager*)[self getChildByTag:kSpriteManager];
	
	AtlasSprite *bear = [AtlasSprite spriteWithRect:CGRectMake (620,0,85,70) spriteManager:spriteManager];
	[spriteManager addChild:bear z:4 tag:kBear];
	
	BitmapFontAtlas *scoreLabel = [BitmapFontAtlas bitmapFontAtlasWithString:@"0" fntFile:@"bitmapFont.fnt"];
	[self addChild:scoreLabel z:5 tag:kScoreLabel];
	BitmapFontAtlas *livesLabel = [BitmapFontAtlas bitmapFontAtlasWithString:@"4" fntFile:@"bitmapFont.fnt"];
	[self addChild:livesLabel z:5 tag:kLivesLabel];
	scoreLabel.position = ccp(160,430);
	Sprite* scoreBackground = [Sprite spriteWithFile:@"scoreBackground.png"];
	scoreBackground.position = ccp(155,435);
	[self addChild:scoreBackground];
	livesLabel.position =ccp(270,430);
	[livesLabel setRGB:0 :0 :0];
	messageLabel = [Label labelWithString:@"lives" fontName:@"Marker Felt" fontSize:28];
	[messageLabel setRGB:0 :0 :0];
	messageLabel.position = ccp(265,410);
	[self addChild:messageLabel];
	
	//Initialize Chipmunk:
	cpInitChipmunk();
	
	space = cpSpaceNew();
	cpSpaceResizeStaticHash(space, 20.0f, 10);
	cpSpaceResizeActiveHash(space, 20, 20);
	
	space->gravity = cpv(0, 0);
	space->elasticIterations = space->iterations;
	
	targets = [[NSMutableArray alloc] init];
	for(int i = 0; i < 3; i++)
	{
		Target *t = [[Target alloc] initWithCPBody:[self addSpriteNamed:@"ball-1.png" x:-350 y:-350 type:kColl_Bee]];
		[targets addObject: t];
		[t release];
	}
	pots = [[NSMutableArray alloc] init];
	for(int i = 0; i < 15; i++)
	{int random=arc4random()%4;
		Target *p = [Target alloc];
		switch (random) {
			case 0:
				[p initWithCPBody:[self addSpriteNamed:@"honey_pot.png" x:-350 y:-350 type:kColl_Pot]];break;
			case 1:
				[p initWithCPBody:[self addSpriteNamed:@"honey_pot1.png" x:-350 y:-350 type:kColl_Pot]];break;
			case 2:
				[p initWithCPBody:[self addSpriteNamed:@"honey_pot2.png" x:-350 y:-350 type:kColl_Pot]];;break;
			case 3:
				[p initWithCPBody:[self addSpriteNamed:@"honey_pot3.png" x:-350 y:-350 type:kColl_Pot]];break;
			default:
				[p initWithCPBody:[self addSpriteNamed:@"honey_pot.png" x:-350 y:-350 type:kColl_Pot]];break;
				break;
		}
		[pots addObject: p];
		[p release];
	}

	speedUp = [[Target alloc] initWithCPBody:[self addSpriteNamed:@"bonusSpeedUp.png" x:-850 y:-450 type:kColl_SpeedUp]];
	speedDown = [[Target alloc] initWithCPBody:[self addSpriteNamed:@"bonusSpeedDown.png" x:-850 y:-400 type:kColl_SpeedDown]];
	life = [[Target alloc] initWithCPBody:[self addSpriteNamed:@"bonusLife.png" x:-850 y:-550 type:kColl_Life]];
	//shield = [[Target alloc] initWithCPBody:[self addSpriteNamed:@"bonusShield.png" x:-850 y:-500 type:kColl_Shield]];	
	b = [[Target alloc] initWithCPBody:[self makeBirdX:160 y:20]];
	
	isTouchEnabled = YES;
	isAccelerometerEnabled = YES;
	[[UIAccelerometer sharedAccelerometer] setUpdateInterval:(1.0 / kFPS)];
	[self setupSound];
	[_player play];
	[self startGame];
	//Update Chipmunk	
	[self schedule:@selector(step:)];
	[self schedule: @selector(step1sec:) interval:.5];
	[self schedule: @selector(step15:) interval:10];
	[self setupCollisionHandlers];
	return self;
}
static int bulletCollision(cpShape *a, cpShape *b, cpContact *contacts, int numContacts, cpFloat normal_coef, void *data)
{
	
	Game *game = (Game*) data;
	AudioServicesPlaySystemSound (game.hitSoundObject);
	//printf("collide%D,%D",contacts->p.x,contacts->p.y );
		//a->body->p = cpv(800,800);
		b->body->p = cpv(-800,-800);
	[game createExplosionX:contacts->p.x y:contacts->p.y];
	/*id a1= [ScaleBy actionWithDuration:.25 scale:.5];
	id a2= [ScaleBy actionWithDuration:.25 scale:1.0];
	id a3= [Sequence actions:a1,a2,nil];
	AtlasSpriteManager *spriteManager = (AtlasSpriteManager*)[game getChildByTag:kSpriteManager];
	AtlasSprite *bird = (AtlasSprite*)[spriteManager getChildByTag:kBear];
	[bird runAction:a3];*/
	game.hit=YES;
	return 0;
}
static int potCollision(cpShape *a, cpShape *b, cpContact *contacts, int numContacts, cpFloat normal_coef, void *data)
{
	Game *game = (Game*) data;
AudioServicesPlaySystemSound (game.slurpSoundObject);
	//printf("collide%D,%D",contacts->p.x,contacts->p.y );
	//a->body->p = cpv(800,800);
	b->body->p = cpv(-800,-800);
	//[game createExplosionX:contacts->p.x y:contacts->p.y];
	id a1= [RotateBy actionWithDuration:.5 angle:360];
	AtlasSpriteManager *spriteManager = (AtlasSpriteManager*)[game getChildByTag:kSpriteManager];
	AtlasSprite *bird = (AtlasSprite*)[spriteManager getChildByTag:kBear];
	[bird runAction:a1];
	game.catch=YES;
	return 0;
}
static int bonusSpeedUpCollision(cpShape *a, cpShape *b, cpContact *contacts, int numContacts, cpFloat normal_coef, void *data)
{
	
	Game *game = (Game*) data;
	AudioServicesPlaySystemSound (game.slurpSoundObject);
	//printf("collide%D,%D",contacts->p.x,contacts->p.y );
	//a->body->p = cpv(800,800);
	b->body->p = cpv(-800,-800);
	//[game createExplosionX:contacts->p.x y:contacts->p.y];
	id a1= [RotateBy actionWithDuration:.5 angle:360];
	AtlasSpriteManager *spriteManager = (AtlasSpriteManager*)[game getChildByTag:kSpriteManager];
	AtlasSprite *bird = (AtlasSprite*)[spriteManager getChildByTag:kBear];
	[bird runAction:a1];
	
	game.catchSpeedUp=YES;
	return 0;
}
static int bonusSpeedDownCollision(cpShape *a, cpShape *b, cpContact *contacts, int numContacts, cpFloat normal_coef, void *data)
{
	
	Game *game = (Game*) data;
	AudioServicesPlaySystemSound (game.slurpSoundObject);
	//printf("collide%D,%D",contacts->p.x,contacts->p.y );
	//a->body->p = cpv(800,800);
	b->body->p = cpv(-800,-800);
	//[game createExplosionX:contacts->p.x y:contacts->p.y];
	id a1= [RotateBy actionWithDuration:.5 angle:360];
	AtlasSpriteManager *spriteManager = (AtlasSpriteManager*)[game getChildByTag:kSpriteManager];
	AtlasSprite *bird = (AtlasSprite*)[spriteManager getChildByTag:kBear];
	[bird runAction:a1];
	game.catchSpeedDown=YES;
	return 0;
}
static int bonusLifeCollision(cpShape *a, cpShape *b, cpContact *contacts, int numContacts, cpFloat normal_coef, void *data)
{
	
	Game *game = (Game*) data;
	AudioServicesPlaySystemSound (game.slurpSoundObject);
	//printf("collide%D,%D",contacts->p.x,contacts->p.y );
	//a->body->p = cpv(800,800);
	b->body->p = cpv(-800,-800);
	//[game createExplosionX:contacts->p.x y:contacts->p.y];
	id a1= [RotateBy actionWithDuration:.5 angle:360];
	AtlasSpriteManager *spriteManager = (AtlasSpriteManager*)[game getChildByTag:kSpriteManager];
	AtlasSprite *bird = (AtlasSprite*)[spriteManager getChildByTag:kBear];
	[bird runAction:a1];
	game.catchLife=YES;
	return 0;
}
static int bonusShieldCollision(cpShape *a, cpShape *b, cpContact *contacts, int numContacts, cpFloat normal_coef, void *data)
{
	Game *game = (Game*) data;
	AudioServicesPlaySystemSound (game.slurpSoundObject);
	//printf("collide%D,%D",contacts->p.x,contacts->p.y );
	//a->body->p = cpv(800,800);
	b->body->p = cpv(-800,-800);
	//[game createExplosionX:contacts->p.x y:contacts->p.y];
	id a1= [RotateBy actionWithDuration:.5 angle:360];
	AtlasSpriteManager *spriteManager = (AtlasSpriteManager*)[game getChildByTag:kSpriteManager];
	AtlasSprite *bird = (AtlasSprite*)[spriteManager getChildByTag:kBear];
	[bird runAction:a1];
	game.catchShield=YES;
	return 0;
}
-(void) setupSound
{// Get the main bundle for the app
	CFBundleRef mainBundle;
	mainBundle = CFBundleGetMainBundle ();
	
	// Get the URL to the sound file to play
	slurpSound  =	CFBundleCopyResourceURL (
											 mainBundle,
											 CFSTR ("slurp"),
											 CFSTR ("wav"),
											 NULL
											 );
	
	// Create a system sound object representing the sound file
	AudioServicesCreateSystemSoundID (
									  slurpSound,
									  &slurpSoundObject
									  );
	// Get the URL to the sound file to play
	hitSound  =	CFBundleCopyResourceURL (
										 mainBundle,
										 CFSTR ("Illegal"),
										 CFSTR ("wav"),
										 NULL
										 );
	
	// Create a system sound object representing the sound file
	AudioServicesCreateSystemSoundID (
									  hitSound,
									  &hitSoundObject
									  );
	// Get the URL to the sound file to play
	gameOverSound  =	CFBundleCopyResourceURL (
												 mainBundle,
												 CFSTR ("fanfare1"),
												 CFSTR ("wav"),
												 NULL
												 );
	
	// Create a system sound object representing the sound file
	AudioServicesCreateSystemSoundID (
									  gameOverSound,
									  &gameOverSoundObject
									  );
	NSURL *fileURL = [[NSURL alloc] initFileURLWithPath: [[NSBundle mainBundle] pathForResource:@"march" ofType:@"mp3"]];
	self._player = [[AVAudioPlayer alloc] initWithContentsOfURL:fileURL error:nil];	
	self._player.numberOfLoops =-1;
	self._player.volume=.1;
}	
-(void) step15: (ccTime) delta
{
	int randomx = 20 + arc4random() % 280;
	int random=arc4random() % 3;
switch (random) {
	case 0:
		[speedUp fireFromX:randomx y:500 atSpeedX:0 atSpeedY:-150];
		break;
	case 1:
		[speedDown fireFromX:randomx y:500 atSpeedX:0 atSpeedY:-150];
		break;
	case 2:
		[life fireFromX:randomx y:500 atSpeedX:0 atSpeedY:-150];
		break;
	/*case 3:
		[shield fireFromX:randomx y:500 atSpeedX:0 atSpeedY:-150];
		break;*/
	default:
		[speedUp fireFromX:randomx y:500 atSpeedX:0 atSpeedY:-150];
		break;
}

}
-(void) step1sec: (ccTime) delta
{
	if(gameSuspended) return;
	self.checkForGameOver;
	NSString *scoreStr = [NSString stringWithFormat:@"%d",dataManager.score];
	BitmapFontAtlas *scoreLabel = (BitmapFontAtlas*)[self getChildByTag:kScoreLabel];
	[scoreLabel setString:scoreStr];
	
		int speed;

		speed = -200+speedModifier;
		int random=arc4random()%2;
		switch (random) {
			case 0:
				for(Target *t in targets)
				{printf("bee shoot\n");
					if([t ready])
				{
					printf("bee ready\n");
					int randomx = 20 + arc4random() % 280;
					[t fireFromX:randomx y:500 atSpeedX:0 atSpeedY:speed];
					[t setReady: NO];
					break;
				}
				}
				break;
			case 1:

				for(Target *p in pots)
				{printf("pot shoot\n");
					if([p ready])
					{
						printf("pot ready\n");
						int randomx = 20 + arc4random() % 280;
						[p fireFromX:randomx y:500 atSpeedX:0 atSpeedY:speed];
						[p setReady: NO];
						break;
					}
				}
				break;
	}
	if (dataManager.score==1000  && reachedScore==NO)
	{
		[[NSNotificationCenter defaultCenter] postNotificationName:@"goodScore" object:@""];
		reachedScore=YES;
	}
}

- (void)dealloc {
	NSLog(@"Game::dealloc");
	[targets release];
	[pots release];
	[bonus release];
	[b release]; [speedUp release];
	[speedDown release]; 
	[life release]; 
	[messageLabel release];
	[_player release];
	[dataManager release];
	[super dealloc];
}
-(cpBody *) addSpriteNamed: (NSString *)name x: (float)x y:(float)y type:(unsigned int) type {
	
	UIImage *image = [UIImage imageNamed:name];  
	Sprite *sprite = [Sprite spriteWithFile:name];
	[self addChild: sprite z:2];
	sprite.position = cpv(x,y);
	
	int num_vertices = 4;
	cpVect verts[] = {
		cpv([image size].width/2 * -1, [image size].height/2 * -1),
		cpv([image size].width/2 * -1, [image size].height/2),
		cpv([image size].width/2, [image size].height/2),
		cpv([image size].width/2, [image size].height/2 * -1)
	};
	
	// all objects need a body
	cpBody *body = cpBodyNew(1.0, cpMomentForPoly(1.0, num_vertices, verts, cpvzero));
	body->p = cpv(x, y);
	cpSpaceAddBody(space, body);
	
	// as well as a shape to represent their collision box
	cpShape* shape = cpCircleShapeNew(body, [image size].width / 2, cpvzero);
	shape->data = sprite;
	shape -> collision_type = type;
		//shape->e = 1.1; // elasticity
		//shape->u = 1.1; // friction
	shape -> group =2;
	cpSpaceAddShape(space, shape);
	return body;
}
-(cpBody *) makeBirdX: (float) x y:(float) y 
{
	AtlasSpriteManager *spriteManager = (AtlasSpriteManager*)[self getChildByTag:kSpriteManager];
	AtlasSprite *bird = (AtlasSprite*)[spriteManager getChildByTag:kBear];
	
	bird_pos.x = 160;
	bird_pos.y = 35;
	bird.position = bird_pos;
	
	bird_acc.x = 0;
	bird_acc.y = -550.0f;
	
	birdLookingRight = YES;
	bird.scaleX = 1.0f;
	
	cpVect verts[] = {
		cpv(-40,-40),
		cpv(-40, 40),
		cpv(40, 40),
		cpv(40,-40),
	};
	
	cpBody *birdBod = cpBodyNew(100.0f, INFINITY);
	birdBod->p = cpv(bird_pos.x, bird_pos.y);
	birdBod->v = cpv(0, 0);
	
	cpSpaceAddBody(space, birdBod);
	
	cpShape * birdShape = cpPolyShapeNew(birdBod, 4, verts, cpvzero);
	birdShape->e = 0.9f; birdShape->u = 0.9f;
	birdShape->data = bird;
	birdShape -> group =1;
	birdShape->collision_type = kColl_Bear; 
	cpSpaceAddCollisionPairFunc(space, kColl_Bear, kColl_Bee, &bulletCollision, self);
	cpSpaceAddCollisionPairFunc(space, kColl_Bear, kColl_Pot, &potCollision, self);
	cpSpaceAddCollisionPairFunc(space, kColl_Bear, kColl_SpeedUp, &bonusSpeedUpCollision, self);
	cpSpaceAddCollisionPairFunc(space, kColl_Bear, kColl_SpeedDown, &bonusSpeedDownCollision, self);
	cpSpaceAddCollisionPairFunc(space, kColl_Bear, kColl_Life, &bonusLifeCollision, self);
	cpSpaceAddCollisionPairFunc(space, kColl_Bear, kColl_Shield, &bonusShieldCollision, self);
	cpSpaceAddShape(space, birdShape);

	return birdBod;
	
}
- (void)setupCollisionHandlers
{
	
}
-(void)checkForGameOver
{		
	if (catchSpeedDown&& speedModifier >-500)
	{speedModifier+=100;
		printf("speedm%d", speedModifier);
		catchSpeedDown=NO;
	}
	if (catchSpeedUp&& speedModifier <500)
	{speedModifier-=100;
		printf("speedm%d", speedModifier);
		catchSpeedUp=NO;
		
		/*NSString *scoreStr = [NSString stringWithFormat:@"%d",score];
		 
		 BitmapFontAtlas *scoreLabel = (BitmapFontAtlas*)[self getChildByTag:kScoreLabel];
		 [scoreLabel setString:scoreStr];
		 id orbit = [ScaleBy actionWithDuration:.2 scale:1.5];
		 id orbit2= [orbit2 reverse];
		 id orbit3= [Sequence actions:orbit, orbit2, nil];
		 //[scoreLabel runAction:orbit3];*/
		
	}
	if (catchLife)
	{lives++;
		printf("lives%d", lives);
		NSString* string=[NSString stringWithFormat:@"%d",lives+1];
		BitmapFontAtlas *livesLabel = (BitmapFontAtlas*)[self getChildByTag:kLivesLabel];
		[livesLabel setString:string];
		catchLife=NO;
	}
	if (catchShield)
	{catchShield=NO;
		printf("shield");
		//bear.displayFrame=shield;
		/*NSString *scoreStr = [NSString stringWithFormat:@"%d",score];
		 
		 BitmapFontAtlas *scoreLabel = (BitmapFontAtlas*)[self getChildByTag:kScoreLabel];
		 [scoreLabel setString:scoreStr];
		 id orbit = [ScaleBy actionWithDuration:.2 scale:1.5];
		 id orbit2= [orbit2 reverse];
		 id orbit3= [Sequence actions:orbit, orbit2, nil];
		 //[scoreLabel runAction:orbit3];*/
	}
		if (catch)
	{dataManager.score+=1000;
		catch=NO;
		
		/*NSString *scoreStr = [NSString stringWithFormat:@"%d",score];
		 
		 BitmapFontAtlas *scoreLabel = (BitmapFontAtlas*)[self getChildByTag:kScoreLabel];
		 [scoreLabel setString:scoreStr];
		 id orbit = [ScaleBy actionWithDuration:.2 scale:1.5];
		 id orbit2= [orbit2 reverse];
		 id orbit3= [Sequence actions:orbit, orbit2, nil];
		 //[scoreLabel runAction:orbit3];*/
	}
	
	if (hit)
{
	
	printf("lives %d", lives);
	
	if (lives>0)
	{lives--;
		hit=NO;
		NSString* string=[NSString stringWithFormat:@"%d",lives+1];
		BitmapFontAtlas *livesLabel = (BitmapFontAtlas*)[self getChildByTag:kLivesLabel];
		[livesLabel setString:string];
	}
	else{[_player stop];
		AudioServicesPlaySystemSound (self.gameOverSoundObject);
		
		[self showHighscores];
	}
}
	
}

-(void) createExplosionX: (float) x y: (float) y
{
	ParticleSystem *emitter = [RockExplosion node];
	emitter.position = cpv(x,y);
	[self addChild: emitter];
}

- (void)startGame {
	NSLog(@"startGame");

	dataManager.score = 0;
	
	[self resetClouds];
	
	[[UIApplication sharedApplication] setIdleTimerDisabled:YES];
	gameSuspended = NO;
	level = 1;
	lives = 3;
	speedModifier=0;
}

static void
eachShape(void *ptr, void* unused)
{
	cpShape *shape = (cpShape*) ptr;
	Sprite *sprite = shape->data;
	if( sprite ) {
		cpBody *body = shape->body;
		[sprite setPosition: cpv( body->p.x, body->p.y)];
		[sprite setRotation: (float) CC_RADIANS_TO_DEGREES( -body->a )];
	}
}
-(void) updateBear
{
	//label = [Label labelWithString:loseString fontName:@"Marker Felt" fontSize:14];
	//[self addChild:label];
	if([b getX] < 35)
		{
			[b boundaryCheckLeft];
		}
	if([b getX] > 285)
	{
		[b boundaryCheckRight];
	}
}

-(void) updateTargets
{
	int beeCounter=0;
	int potCounter=0;
	//label = [Label labelWithString:loseString fontName:@"Marker Felt" fontSize:14];
	//[self addChild:label];
	for(Target *t in targets)
	{
		if([t getY] < -20)
		{
			//printf("reset bee\n");
			[t resetPosition];
			[t setReady: YES];
		}
	}
	for(Target *p in pots)
	{
		if([p getY] < -20)
		{
			//printf("reset pot\n");
			[p resetPosition];
			[p setReady: YES];
		}
	}
	for(Target *t in targets)
	{
		if((![t ready]) && [t getY] < -20)
		{
			beeCounter++;
			//printf("%d\n", beeCounter);
			printf("bee ready\n");
		}
		if(beeCounter >= 3)
		{
			printf("beeCounter >=3\n");
			for(Target *t in targets)
			{
				[t setReady: YES];
				for(Target *t in targets)
				{printf("bee shoot\n");
					if([t ready])
					{
						printf("bee ready\n");
						int randomx = 20 + arc4random() % 280;
						[t fireFromX:randomx y:500 atSpeedX:0 atSpeedY:100];
						[t setReady: NO];
						break;
					}
				}
				
			}
		}
	}
	for(Target *p in pots)
	{
		if(![p ready]) //&& [p getY] < -20)
		{
			potCounter++;
			
			//printf("%d", potCounter);
		}
		//printf("%d\n", potCounter);
		if(potCounter >= 15)
		{
			printf("potCounter >=15\n");
			for(Target *p in pots)
			{
				[p setReady: YES];
			}
			if([p ready])
			{
				printf("pot ready\n");
				int randomx = 20 + arc4random() % 280;
				[p fireFromX:randomx y:500 atSpeedX:0 atSpeedY:100];
				[p setReady: NO];
				break;
			}			
		}
	}
}

- (void)step:(ccTime)dt {
//	NSLog(@"Game::step");
	if(gameSuspended) return;
	int steps = 2;
	cpFloat time = dt/(cpFloat)steps;
	
	for(int i=0; i<steps; i++){
		cpSpaceStep(space, time);
	}
	cpSpaceHashEach(space->activeShapes, &eachShape, nil);
	cpSpaceHashEach(space->staticShapes, &eachShape, nil);
	
		
	[super step:dt];
	[self updateTargets];
	[self updateBear];
	AtlasSpriteManager *spriteManager = (AtlasSpriteManager*)[self getChildByTag:kSpriteManager];
	
	int t;
		t = kCloudsStartTag;
		for(t; t < kCloudsStartTag + kNumClouds; t++) {
			AtlasSprite *cloud = (AtlasSprite*)[spriteManager getChildByTag:t];
			CGPoint pos = cloud.position;
			pos.y -= 1
			* cloud.scaleY * 0.8f;
			if(pos.y < -cloud.contentSize.height/2) {
				currentCloudTag = t;
				[self resetCloud];
			} else {
				cloud.position = pos;
			}
		}
	}

- (void)showHighscores {
	NSLog(@"showHighscores");
	gameSuspended = YES;
	[[UIApplication sharedApplication] setIdleTimerDisabled:NO];
	[[NSNotificationCenter defaultCenter] postNotificationName:@"enterName" object:@""];
	NSLog(@"score = %d",dataManager.score);
	}

- (void)accelerometer:(UIAccelerometer*)accelerometer didAccelerate:(UIAcceleration*)acceleration {
	if(gameSuspended) return;
	float accel_filter = 0.1f;
	
	bird_vel.x = bird_vel.x * accel_filter + acceleration.x * (1.0f - accel_filter) * 500.0f;
	[b setSpeedX:bird_vel.x Y:0];
	if (acceleration.y <0)
	{
//	for(Target *t in targets)
//	{[t setSpeedX:0 Y:-250+acceleration.y*100];
//		multiplier = -acceleration.y*25;
//	}
	}
	
	/*static float prevX=0, prevY=0;
	
#define kFilterFactor 0.05f
	
	float accelX = (float) acceleration.x * kFilterFactor + (1- kFilterFactor)*prevX;
	float accelY = (float) acceleration.y * kFilterFactor + (1- kFilterFactor)*prevY;
	
	prevX = accelX;
	prevY = accelY;
	
	CGPoint v = ccp( accelX, accelY);
	
	space->gravity = ccpMult(v, 200);*/
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
	NSLog(@"alertView:clickedButtonAtIndex: %i",buttonIndex);

	if(buttonIndex == 0) {
		[self startGame];
	} else {
		[self startGame];
	}
}


@end
