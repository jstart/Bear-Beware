#import "cocos2d.h"
#import "Game.h"
#import "Main.h"
#import "MenuScene.h"
#import "WebViewController.h"
#import "NameEntryViewController.h"

@interface AppDelegate : NSObject <UIApplicationDelegate, UIAccelerometerDelegate>
{
	UIWindow *window;
	NSNotificationCenter* notifyCenter;
	WebViewController* webViewController;
	NameEntryViewController* nameEntry; 
}
@property(nonatomic,retain) UIWindow *window;
@property (nonatomic, retain) NSNotificationCenter *notifyCenter;
@property (nonatomic, retain) WebViewController *webViewController;
@property (nonatomic, retain) NameEntryViewController *nameEntry;

- (void) loadHtml:(NSString *) name withTitle:(NSString *) title;
- (void) hideUIViewController:(UIViewController *) controller;
- (void) showUIViewController:(UIViewController *) controller;

@end
