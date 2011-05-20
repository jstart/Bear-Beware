#import "AppDelegate.h"
#import "SlidingMessageViewController.h"

@implementation AppDelegate
@synthesize window, notifyCenter, webViewController, nameEntry;

- (void)applicationDidFinishLaunching:(UIApplication *)application {

	[[UIApplication sharedApplication] setStatusBarHidden:YES animated:YES];
	self.notifyCenter = [NSNotificationCenter defaultCenter];
	[notifyCenter addObserver:self selector:@selector(trackNotifications:) name:nil object:nil];
	
	window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
//	[window setUserInteractionEnabled:YES];
//	[window setMultipleTouchEnabled:YES];	

	[[Director sharedDirector] setPixelFormat:kRGBA8];
	[[Director sharedDirector] attachInWindow:window];
//	[[Director sharedDirector] setDisplayFPS:YES];
	[[Director sharedDirector] setAnimationInterval:1.0/kFPS];

	[Texture2D setDefaultAlphaPixelFormat:kTexture2DPixelFormat_RGBA8888]; 
	
	[window makeKeyAndVisible];

	/*Scene *scene = [[Scene node] addChild:[Game node] z:0];
	 */
	MenuScene* scene =[MenuScene node];
	[[Director sharedDirector] runWithScene: scene];
	SlidingMessageViewController *msgVC = [[SlidingMessageViewController alloc] initWithTitle:@"Welcome to Bear Beware" message:@"Press Play!"];   
	[window addSubview:msgVC.view];
	
	// Show the message for 5 seconds
	[msgVC showMsgWithDelay:3];

	
}

- (void)dealloc {
	[window release];
	[webViewController release];
		[super dealloc];
}



- (void)applicationWillResignActive:(UIApplication*)application {
	[[Director sharedDirector] pause];
}

- (void)applicationDidBecomeActive:(UIApplication*)application {
	[[Director sharedDirector] resume];
}

- (void)applicationDidReceiveMemoryWarning:(UIApplication*)application {
	[[TextureMgr sharedTextureMgr] removeAllTextures];
}

- (void)applicationSignificantTimeChange:(UIApplication*)application {
	[[Director sharedDirector] setNextDeltaTimeZero:YES];
}

- (void) trackNotifications: (NSNotification *) notification
{
	id nname = [notification name];
	
	if([nname isEqual:@"about"])
	{
		[self loadHtml:@"about" withTitle:@"About"];
	}
	else if([nname isEqual:@"moreGames"])
	{
		[self loadHtml:@"games" withTitle:@"Online Scores"];
	}
	else if([nname isEqual:@"goodScore"])
	{
		SlidingMessageViewController *msgVC = [[SlidingMessageViewController alloc] initWithTitle:@"You got Points" message:@"Keep Going!"];   
		[window addSubview:msgVC.view];
		
		// Show the message for 5 seconds
		[msgVC showMsgWithDelay:1];
	}
	else if([nname isEqual:@"removeWebView"])
	{
		[self hideUIViewController:webViewController];
		
		[webViewController release];
	webViewController = nil;
	}
	else if([nname isEqual:@"enterName"])
	{
		NameEntryViewController *entry = [[NameEntryViewController alloc] init];
		self.nameEntry = entry;
		[entry release];
		
		[self showUIViewController:nameEntry];
	}
	else if([nname isEqual:@"removeNameEntry"])
	{
		[self hideUIViewController:nameEntry];
		
		[nameEntry release];
		nameEntry = nil;
	}
}

- (void) loadHtml:(NSString *) name withTitle:(NSString *) title
{
	WebViewController *web = [[WebViewController alloc] init];
	self.webViewController = web;
	[web release];
	
	[self showUIViewController:webViewController];
	
	[webViewController loadHtml:name withTitle:title];
}

-(void)animDone:(NSString*) animationID finished:(BOOL) finished context:(void*) context
{	
	[[Director sharedDirector] resume];
}

- (void) showUIViewController:(UIViewController *) controller
{
	[[Director sharedDirector] pause];
	
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:.5];
	[UIView setAnimationTransition:UIViewAnimationTransitionCurlUp forView:[[Director sharedDirector] openGLView] cache:YES];
	
	[[[Director sharedDirector] openGLView] addSubview:controller.view];
	
	[UIView commitAnimations];
}

- (void) hideUIViewController:(UIViewController *) controller
{
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:.5];
	[UIView setAnimationDelegate:self];
	[UIView setAnimationDidStopSelector:@selector(animDone:finished:context:)];
	
	[UIView setAnimationTransition:UIViewAnimationTransitionCurlDown forView:[[Director sharedDirector] openGLView] cache:YES];
	
	[controller.view removeFromSuperview];
	
	[UIView commitAnimations];
}


@end
