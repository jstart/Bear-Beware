/*
 This work is licensed under the Creative Commons Attribution-Share Alike 3.0 United States License. 
 To view a copy of this license, visit http://creativecommons.org/licenses/by-sa/3.0/us/ or 
 send a letter to Creative Commons, 171 Second Street, Suite 300, San Francisco, California, 94105, USA.
 
 Jed Laudenslayer
 http://kwigbo.com
 
 */

#import <UIKit/UIKit.h>

@interface WebViewController : UIViewController
{
	IBOutlet UIWebView *webView;
	NSString *navTitle;
	NSString *htmlFileName;
	UIActivityIndicatorView *activityIndicator;
	IBOutlet UINavigationBar *navBar;
	
	BOOL loadURL;
}

@property (nonatomic, retain) UIWebView *webView;
@property (nonatomic, retain) UIActivityIndicatorView *activityIndicator;
@property (nonatomic, retain) UINavigationBar *navBar;

@property (nonatomic, retain) NSString *navTitle;
@property (nonatomic, retain) NSString *htmlFileName;

- (IBAction) cancel;
- (void) loadHtml:(NSString *) name withTitle:(NSString *) title;

@end
