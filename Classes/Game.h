#import "cocos2d.h"
#import "Main.h"
#import "chipmunk.h"
#import "BeeObstacle.h"
#import <AudioToolbox/AudioToolbox.h>
#import <AVFoundation/AVFoundation.h>
#import "AppDelegate.h"
#import "DataManager.h"

@interface Game : Main
{
	ccVertex2F bird_pos;
	ccVertex2F bird_vel;
	ccVertex2F bird_acc;	

	DataManager *dataManager;
	
	cpSpace *space;
	NSMutableArray *targets;
	NSMutableArray *pots;
	NSMutableArray *bonus;
	
	CCLabelTTF *messageLabel;
	
	BeeObstacle *b;
	BeeObstacle *speedUp;
	BeeObstacle *speedDown;
	BeeObstacle *life;
	
	BOOL hit;
	BOOL catch;
	BOOL catchSpeedUp;
	BOOL catchSpeedDown;
	BOOL catchLife;
	BOOL catchShield;
	BOOL gameSuspended;
	BOOL birdLookingRight;
	BOOL reachedScore;
	
	int score;
	int lives;
	int level;
	int speedModifier;
	
	CFURLRef		slurpSound;
	SystemSoundID	slurpSoundObject;
	CFURLRef		hitSound;
	SystemSoundID	hitSoundObject;
	CFURLRef		gameOverSound;
	SystemSoundID	gameOverSoundObject;
	AVAudioPlayer						*_player;
}
@property (nonatomic, retain) DataManager *dataManager;

@property (nonatomic, assign)	AVAudioPlayer	*_player;
@property (readwrite)	CFURLRef		gameOverSound;
@property (readonly)	SystemSoundID	gameOverSoundObject;
@property (readwrite)	CFURLRef		hitSound;
@property (readonly)	SystemSoundID	hitSoundObject;
@property (readwrite)	CFURLRef		slurpSound;
@property (readonly)	SystemSoundID	slurpSoundObject;


@property (nonatomic, retain) NSMutableArray *targets;
@property (nonatomic, retain) NSMutableArray *pots;
@property (nonatomic, retain) NSMutableArray *bonus;

@property (nonatomic, retain) BeeObstacle *b;
@property (nonatomic, retain) BeeObstacle *speedUp;
@property (nonatomic, retain) BeeObstacle *speedDown;
@property (nonatomic, retain) BeeObstacle *life;

@property (readwrite) BOOL hit;
@property (readwrite) BOOL catch;
@property (readwrite) BOOL catchSpeedUp;
@property (readwrite) BOOL catchSpeedDown;
@property (readwrite) BOOL catchLife;
@property (readwrite) BOOL catchShield;

@property (nonatomic,retain)   CCLabelTTF *messageLabel;

@end
