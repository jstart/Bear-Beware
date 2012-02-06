#import "cocos2d.h"

//#define RESET_DEFAULTS

#define kFPS 60

#define kNumClouds			12


enum {
	kSpriteManager = 0,
	kBear,
	kScoreLabel,
	kLivesLabel,
	kCloudsStartTag = 100,
	kPlatformsStartTag = 200,
	kBonusStartTag = 300
};

enum {
	kBonus5 = 0,
	kBonus10,
	kBonus50,
	kBonus100,
	kNumBonuses
};

@interface Main : CCLayer
{
	int currentCloudTag;
}
- (void)resetClouds;
- (void)resetCloud;
- (void)step:(ccTime)dt;
@end
