#import "Highscores.h"
#import "Main.h"
#import "Game.h"
#import "TwitterRequest.h"
#import "AppDelegate.h"

@interface Highscores (Private)
- (void)loadCurrentPlayer;
- (void)loadHighscores;
- (void)updateHighscores;
- (void)saveCurrentPlayer;
- (void)saveHighscores;
- (void)button1Callback:(id)sender;
- (void)button2Callback:(id)sender;
- (void)button3Callback:(id)sender;
@end


@implementation Highscores
@synthesize dataManager;

- (id)initWithScore:(int)lastScore {
	NSLog(@"Highscores::init");
	
	if(![super init]) return nil;

	NSLog(@"lastScore = %d",lastScore);
	
	currentScore = lastScore;

	NSLog(@"currentScore = %d",currentScore);
	
	[self loadCurrentPlayer];
	NSLog(currentPlayer);
	[self loadHighscores];
	[self updateHighscores];
	if(currentScorePosition >= 0) {
		[self saveHighscores];
	}
	
		AtlasSpriteManager *spriteManager = (AtlasSpriteManager*)[self getChildByTag:kSpriteManager];
	
	AtlasSprite *title = [AtlasSprite spriteWithRect:CGRectMake(608,192,225,57) spriteManager:spriteManager];
	[spriteManager addChild:title z:5];
	title.position = ccp(160,420);

	float start_y = 360.0f;
	float step = 27.0f;
	int count = 0;
	for(NSMutableArray *highscore in highscores) {
		NSString *player = [highscore objectAtIndex:0];
		int score = [[highscore objectAtIndex:1] intValue];
		
		Label *label1 = [Label labelWithString:[NSString stringWithFormat:@"%d",(count+1)] dimensions:CGSizeMake(30,40) alignment:UITextAlignmentRight fontName:@"Arial" fontSize:14];
		[self addChild:label1 z:5];
		[label1 setRGB:0 :0 :0];
		[label1 setOpacity:200];
		label1.position = ccp(15,start_y-count*step-2.0f);
		
		Label *label2 = [Label labelWithString:player dimensions:CGSizeMake(240,40) alignment:UITextAlignmentLeft fontName:@"Arial" fontSize:16];
		[self addChild:label2 z:5];
		[label2 setRGB:0 :0 :0];
		label2.position = ccp(160,start_y-count*step);

		Label *label3 = [Label labelWithString:[NSString stringWithFormat:@"%d",score] dimensions:CGSizeMake(290,40) alignment:UITextAlignmentRight fontName:@"Arial" fontSize:16];
		[self addChild:label3 z:5];
		[label3 setRGB:0 :0 :0];
		[label3 setOpacity:200];
		label3.position = ccp(160,start_y-count*step);
		
		count++;
		if(count == 10) break;
	}

	MenuItem *button1 = [MenuItemImage itemFromNormalImage:@"playAgainButton.png" selectedImage:@"playAgainButton.png" target:self selector:@selector(button1Callback:)];
	MenuItem *button2 = [MenuItemImage itemFromNormalImage:@"changePlayerButton.png" selectedImage:@"changePlayerButton.png" target:self selector:@selector(button2Callback:)];
	MenuItem *tweet = [MenuItemImage itemFromNormalImage:@"tweetScore.png" selectedImage:@"tweetScore.png" target:self selector:@selector(button3Callback:)];
	Menu *menu = [Menu menuWithItems: tweet, button1, button2, nil];
	
	MenuItem *back_button = [MenuItemImage itemFromNormalImage:@"menu.png" selectedImage:@"menu.png" target:self selector:@selector(back:)];
	Menu *back = [Menu menuWithItems: back_button, nil];
	
	back.position = ccp(35,35);
	
	[menu alignItemsVerticallyWithPadding:9];
	menu.position = ccp(160,78);
	
	[self addChild:menu];
	[self addChild:back];
	
	return self;
}

- (void)dealloc {
	NSLog(@"Highscores::dealloc");
	[highscores release];
	[super dealloc];
}

- (void)loadCurrentPlayer {
	NSLog(@"loadCurrentPlayer");
	
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	
	currentPlayer = nil;
	currentPlayer = [defaults objectForKey:@"player"];
		if (currentPlayer == nil)
		currentPlayer = @"anonymous";

	NSLog(@"currentPlayer = %@",currentPlayer);
}

- (void)loadHighscores {
	NSLog(@"loadHighscores");
	
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	
	highscores = nil;
	highscores = [[NSMutableArray alloc] initWithArray: [defaults objectForKey:@"highscores"]];
#ifdef RESET_DEFAULTS	
	[highscores removeAllObjects];
#endif
	if([highscores count] == 0) {
		[highscores addObject:[NSArray arrayWithObjects:@"BearBeware",[NSNumber numberWithInt:100000],nil]];
		[highscores addObject:[NSArray arrayWithObjects:@"BearBeware",[NSNumber numberWithInt:75000],nil]];
		[highscores addObject:[NSArray arrayWithObjects:@"BearBeware",[NSNumber numberWithInt:50000],nil]];
		[highscores addObject:[NSArray arrayWithObjects:@"BearBeware",[NSNumber numberWithInt:25000],nil]];
		[highscores addObject:[NSArray arrayWithObjects:@"BearBeware",[NSNumber numberWithInt:10000],nil]];
		[highscores addObject:[NSArray arrayWithObjects:@"BearBeware",[NSNumber numberWithInt:5000],nil]];
		[highscores addObject:[NSArray arrayWithObjects:@"BearBeware",[NSNumber numberWithInt:2000],nil]];
		[highscores addObject:[NSArray arrayWithObjects:@"BearBeware",[NSNumber numberWithInt:1000],nil]];
		[highscores addObject:[NSArray arrayWithObjects:@"BearBeware",[NSNumber numberWithInt:500],nil]];
		[highscores addObject:[NSArray arrayWithObjects:@"BearBeware",[NSNumber numberWithInt:100],nil]];
	}
#ifdef RESET_DEFAULTS	
	[self saveHighscores];
#endif
}

- (void)updateHighscores {
	NSLog(@"updateHighscores");
	
	currentScorePosition = -1;
	int count = 0;
	for(NSMutableArray *highscore in highscores) {
		int score = [[highscore objectAtIndex:1] intValue];
		
		if(currentScore >= score) {
			currentScorePosition = count;
			break;
		}
		count++;
	}
	
	if(currentScorePosition >= 0) {
		[highscores insertObject:[NSArray arrayWithObjects:currentPlayer,[NSNumber numberWithInt:currentScore],nil] atIndex:currentScorePosition];
		[highscores removeLastObject];
	}
}

- (void)saveCurrentPlayer {
	NSLog(@"saveCurrentPlayer");
	NSLog(@"currentPlayer = %@",currentPlayer);
	
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	
	[defaults setObject:currentPlayer forKey:@"player"];
}

- (void)saveHighscores {
	NSLog(@"saveHighscores");
	
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	
	[defaults setObject:highscores forKey:@"highscores"];
}

- (void)button1Callback:(id)sender {
	NSLog(@"button1Callback");
	
	NSString *response = [self submitHighScore:currentPlayer score:currentScore url:@"http://trumandesigns.com"];
	NSLog(@"%@",response);
	Scene *scene = [[Scene node] addChild:[Game node] z:0];
	TransitionScene *ts = [FadeTransition transitionWithDuration:0.5f scene:scene withColorRGB:0xffffff];
	[[Director sharedDirector] replaceScene:ts];
}

- (void)button2Callback:(id)sender {
	NSLog(@"button2Callback");
	changePlayerAlert = [UIAlertView new];
	changePlayerAlert.title = @"Change Player";
	changePlayerAlert.message = @"\n";
	changePlayerAlert.delegate = self;
	[changePlayerAlert addButtonWithTitle:@"Save"];
	[changePlayerAlert addButtonWithTitle:@"Cancel"];
	[changePlayerAlert setAlpha:.1];
	[changePlayerAlert show];

	CGRect frame = changePlayerAlert.frame;
	frame.origin.y -= 100.0f;
	changePlayerAlert.frame = frame;
	
	changePlayerTextField = [[UITextField alloc] initWithFrame:CGRectMake(20, 45, 245, 27)];
	changePlayerTextField.borderStyle = UITextBorderStyleRoundedRect;
	[changePlayerAlert addSubview:changePlayerTextField];
	changePlayerTextField.placeholder = @"Enter your name";
	changePlayerTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
	changePlayerTextField.keyboardType = UIKeyboardTypeDefault;
	changePlayerTextField.returnKeyType = UIReturnKeyDone;
	changePlayerTextField.autocorrectionType = UITextAutocorrectionTypeNo;
	changePlayerTextField.autocapitalizationType = UITextAutocapitalizationTypeNone;
	changePlayerTextField.delegate = self;
	[changePlayerTextField becomeFirstResponder];
}

- (void)button3Callback:(id)sender {
	NSLog(@"button3Callback");
	
	twitterAlert = [UIAlertView new];
	[twitterAlert autoresizesSubviews];
	twitterAlert.title = @"Tweet Your Score";
	twitterAlert.message = @"\n\n\n";
	twitterAlert.delegate = self;
	[twitterAlert addButtonWithTitle:@"Tweet"];
	[twitterAlert addButtonWithTitle:@"Cancel"];
	[twitterAlert show];
	
	CGRect frame = twitterAlert.frame;
	//frame.size.height = 200;
	twitterAlert.frame = frame;
	
	twitterUsernameTextField = [[UITextField alloc] initWithFrame:CGRectMake(20, 45, 245, 27)];
	twitterUsernameTextField.borderStyle = UITextBorderStyleRoundedRect;
	twitterPasswordTextField = [[UITextField alloc] initWithFrame:CGRectMake(20, 80, 245, 27)];
	twitterPasswordTextField.borderStyle = UITextBorderStyleRoundedRect;
	[twitterAlert addSubview:twitterUsernameTextField];
	[twitterAlert addSubview:twitterPasswordTextField];
	twitterUsernameTextField.placeholder = @"Twitter Username";
	twitterUsernameTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
	twitterUsernameTextField.keyboardType = UIKeyboardTypeDefault;
	twitterUsernameTextField.returnKeyType = UIReturnKeyDone;
	twitterUsernameTextField.autocorrectionType = UITextAutocorrectionTypeNo;
	twitterUsernameTextField.autocapitalizationType = UITextAutocapitalizationTypeNone;
	twitterUsernameTextField.delegate = self;
	[twitterUsernameTextField addTarget:self action:@selector(tweet:) forControlEvents:UIControlEventEditingDidEndOnExit];
	
	twitterPasswordTextField.placeholder = @"Twitter Password";
	twitterPasswordTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
	twitterPasswordTextField.keyboardType = UIKeyboardTypeDefault;
	twitterPasswordTextField.returnKeyType = UIReturnKeyDone;
	twitterPasswordTextField.autocorrectionType = UITextAutocorrectionTypeNo;
	twitterPasswordTextField.autocapitalizationType = UITextAutocapitalizationTypeNone;
	twitterPasswordTextField.delegate = self;
	[twitterPasswordTextField addTarget:self action:@selector(tweet) forControlEvents:UIControlEventEditingDidEndOnExit];

	
	
}

- (void)draw {
//	NSLog(@"draw");

	if(currentScorePosition < 0) return;
	
	glColor4ub(0,0,0,50);

	float w = 320.0f;
	float h = 27.0f;
	float x = (320.0f - w)/2;
	float y = 359.0f - currentScorePosition * h;

	GLfloat vertices[4][2];	
	GLubyte indices[4] = { 0, 1, 3, 2 };
	
	glVertexPointer(2, GL_FLOAT, 0, vertices);
	glEnableClientState(GL_VERTEX_ARRAY);
	
	vertices[0][0] = x;		vertices[0][1] = y;
	vertices[1][0] = x+w;	vertices[1][1] = y;
	vertices[2][0] = x+w;	vertices[2][1] = y+h;
	vertices[3][0] = x;		vertices[3][1] = y+h;
	
	glDrawElements(GL_TRIANGLE_STRIP, 4, GL_UNSIGNED_BYTE, indices);
	
	glDisableClientState(GL_VERTEX_ARRAY);	
}

- (void)changePlayerDone {
	//currentPlayer = [changePlayerTextField.text retain];
	currentPlayer = [dataManager.playerName retain];

	[self saveCurrentPlayer];
	if(currentScorePosition >= 0) {
		[highscores removeObjectAtIndex:currentScorePosition];
		[highscores addObject:[NSArray arrayWithObjects:@"bearBeware",[NSNumber numberWithInt:0],nil]];
		[self saveHighscores];
		Highscores *h = [[Highscores alloc] initWithScore:currentScore];
		Scene *scene = [[Scene node] addChild:h z:0];
		[[Director sharedDirector] replaceScene:[FadeTransition transitionWithDuration:1 scene:scene withColorRGB:0xffffff]];
	}
}
- (void)tweet {
	NSString* currentUsername = [twitterUsernameTextField.text retain];
	NSString* currentPassword = [twitterPasswordTextField.text retain];
	NSString* tweet = [NSString stringWithFormat:@"%@ just got %d points in Bear Beware! Its 'beary' fun!",currentPlayer, currentScore];
	NSLog(@"%@", tweet);
	TwitterRequest * t = [[TwitterRequest alloc] init];
	t.username = currentUsername;
	t.password = currentPassword;
	[t statuses_update:tweet delegate:self requestSelector:@selector(status_updateCallback:)];
	
		Highscores *h = [[Highscores alloc] initWithScore:currentScore];
		Scene *scene = [[Scene node] addChild:h z:0];
		[[Director sharedDirector] replaceScene:[FadeTransition transitionWithDuration:1 scene:scene withColorRGB:0xffffff]];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
	NSLog(@"alertView:clickedButtonAtIndex: %i",buttonIndex);

	if(buttonIndex == 0) {
		[self changePlayerDone];
	} else {
		// nothing
	}
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
	NSLog(@"textFieldShouldReturn");
	if (textField == twitterPasswordTextField||twitterUsernameTextField)
	{
		[twitterAlert dismissWithClickedButtonIndex:0 animated:YES];
		self.tweet;
	}
	if (textField == changePlayerTextField)
	{
	[changePlayerAlert dismissWithClickedButtonIndex:0 animated:YES];
	[self changePlayerDone];
	}
	return YES;
}

- (void) back:(id) sender
{
	MenuScene *scene=[[MenuScene node] init];
	//Scene *scene = [[Scene node] addChild:[MenuLayer node] z:0];
	
    [[Director sharedDirector] pushScene:[FadeTransition transitionWithDuration:.3 scene:scene]];
}

-(NSString *) submitHighScore:(NSString *)name score:(float) score url:(NSString *) url {
	NSString *appKey = @"86eed8c72412c0c29d48b23865cc1ebd";
	NSString *urlString = [NSString stringWithFormat:@"http://iphonelb.com/ws?app_key=%@&name=%@&score=%f&url=%@",appKey,
						   name,score,url];
	NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:urlString]];
	NSData	     *data = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
	return [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
}

@end
