#import "cocos2d.h"
#import "Main.h"
#import "DataManager.h"

@interface Highscores : Main <UITextFieldDelegate>
{
	NSString *currentPlayer;
	int currentScore;
	int currentScorePosition;
	NSMutableArray *highscores;
	UIAlertView *changePlayerAlert;
	UITextField *changePlayerTextField;
	UIAlertView *twitterAlert;
	UITextField *twitterUsernameTextField;
	UITextField *twitterPasswordTextField;
	
	DataManager *dataManager;
}
@property (nonatomic,retain) DataManager *dataManager;

- (id)initWithScore:(int)lastScore;
-(NSString *) submitHighScore:(NSString *)name score:(float) score url:(NSString *) url;
@end
