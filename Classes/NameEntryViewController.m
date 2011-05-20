/*
 This work is licensed under the Creative Commons Attribution-Share Alike 3.0 United States License. 
 To view a copy of this license, visit http://creativecommons.org/licenses/by-sa/3.0/us/ or 
 send a letter to Creative Commons, 171 Second Street, Suite 300, San Francisco, California, 94105, USA.
 
 Jed Laudenslayer
 http://kwigbo.com
 
 */

#import "NameEntryViewController.h"
#import "DataManager.h"
#import "cocoslive.h"
#import "cocos2d.h"
#import "Highscores.h"

#define MAX_LENGTH 8

@implementation NameEntryViewController

@synthesize nameField, activityIndicator, cancel_btn, dataManager;

- (void)dealloc
{
	[dataManager release];
	[cancel_btn release];
	[activityIndicator release];
	[nameField release];
	[super dealloc];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
	if (self = [super initWithNibName:@"NameEntryViewController" bundle:nibBundleOrNil])
	{
		self.dataManager = [DataManager sharedManager];
	}
	
	return self;
}

- (void)viewDidLoad
{
	if(activityIndicator == nil)
	{
		UIActivityIndicatorView *indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
		self.activityIndicator = indicator;
		[indicator release];
		
		activityIndicator.frame = CGRectMake(290.0, 9.0, activityIndicator.frame.size.width, activityIndicator.frame.size.height);
		
		[self.view addSubview:activityIndicator];
	}
}

- (IBAction) cancel
{
	[[NSNotificationCenter defaultCenter] postNotificationName:@"removeNameEntry" object:@""];
}

- (void) submitScore
{
	[activityIndicator startAnimating];
	
	cancel_btn.enabled = NO;
	NSLog(@"%d", dataManager.score);
	ScoreServerPost *server = [[ScoreServerPost alloc] initWithGameName:@"Bear Beware" gameKey:@"b07a4f9d39e28d23f7d9e2245f89dd70" delegate:self];
	dataManager.playerName = nameField.text;
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	
	[defaults setObject:dataManager.playerName forKey:@"player"];
	NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithCapacity:2];
	[dict setObject:[NSNumber numberWithInt:dataManager.score] forKey:@"cc_score"];
	[dict setObject:nameField.text forKey:@"cc_playername"];
	
	[server updateScore:dict];
	[server release];	
}

////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////// Score Post Delegate ///////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////

-(void) scorePostOk: (id) sender
{
	[activityIndicator stopAnimating];
	[[NSNotificationCenter defaultCenter] postNotificationName:@"removeNameEntry" object:@""];
	Highscores *highscores = [[Highscores alloc] initWithScore:dataManager.score];
	
	Scene *scene = [[Scene node] addChild:highscores z:0];
	[[Director sharedDirector] replaceScene:[FadeTransition transitionWithDuration:1 scene:scene withColorRGB:0xffffff]];
	
	
}

-(void) scorePostFail: (id) sender
{
	[activityIndicator stopAnimating];
	
	NSString *message = nil;
	tPostStatus status = [sender postStatus];
	if( status == kPostStatusPostFailed )
		message = @"Cannot post the score to the server. Retry";
	else if( status == kPostStatusConnectionFailed )
		message = @"Internet connection not available. Enable wi-fi / 3g to post your scores to the server";
	
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Score Post Failed" message:message delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil];  
	alert.tag = 0;
	[alert show];
	[alert release];  
	
	[[NSNotificationCenter defaultCenter] postNotificationName:@"removeNameEntry" object:@""];
}

////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////// TextField Delegate ////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////

- (BOOL) textFieldShouldReturn:(UITextField *) textField
{	
	[textField resignFirstResponder];
	
	[self submitScore];
	
	return YES;
} 

- (void) textFieldDidBeginEditing:(UITextField *) textField
{
	
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (textField.text.length >= MAX_LENGTH && range.length == 0)
        return NO;
    else
		return YES;
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)didReceiveMemoryWarning
{
	[super didReceiveMemoryWarning];
}

@end
