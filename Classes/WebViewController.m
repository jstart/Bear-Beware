/*
 This work is licensed under the Creative Commons Attribution-Share Alike 3.0 United States License. 
 To view a copy of this license, visit http://creativecommons.org/licenses/by-sa/3.0/us/ or 
 send a letter to Creative Commons, 171 Second Street, Suite 300, San Francisco, California, 94105, USA.
 
 Jed Laudenslayer
 http://kwigbo.com
 
 */

#import "WebViewController.h"


@implementation WebViewController

@synthesize webView;
@synthesize navTitle, htmlFileName;
@synthesize activityIndicator;
@synthesize navBar;

- (void) dealloc
{
	[navBar release];
	[activityIndicator release];
	[navTitle release];
	[htmlFileName release];
	[webView release];
	[super dealloc];
}

- (id) initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
	if (self = [super initWithNibName:@"WebViewController" bundle:nibBundleOrNil])
	{
		// Initialization code
	}
	
	return self;
}

- (IBAction) cancel
{
	[[NSNotificationCenter defaultCenter] postNotificationName:@"removeWebView" object:@""];
}

- (void) viewDidLoad
{	
	[self.webView setBackgroundColor:[UIColor blackColor]];
	
	navBar.topItem.title = navTitle;
}

- (void) loadHtml:(NSString *) name withTitle:(NSString *) title
{
	self.webView.hidden = YES;
	self.navTitle = title;
	self.htmlFileName = name;
	
	navBar.topItem.title = navTitle;
	
	if(name == @"games")
	{
		[self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://iphonelb.com/lb/Bubble_Dodge"]]];
		return;
	}
	
	NSString *fullPath = [NSBundle pathForResource:htmlFileName ofType:@"html" inDirectory:[[NSBundle mainBundle] bundlePath]];
	[self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL fileURLWithPath:fullPath]]];
}

- (void) webViewDidStartLoad:(UIWebView *) webView
{
	if(activityIndicator == nil)
	{
		UIActivityIndicatorView *indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
		self.activityIndicator = indicator;
		[indicator release];
		
		activityIndicator.frame = CGRectMake(290.0, 9.0, activityIndicator.frame.size.width, activityIndicator.frame.size.height);
		
		[self.view addSubview:activityIndicator];
	}
	
	[activityIndicator startAnimating];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
	[activityIndicator stopAnimating];
	
	[self performSelector:@selector(showAboutWebView) withObject:nil afterDelay:.2];
}

- (void) showAboutWebView
{
	self.webView.hidden = NO;
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    if (navigationType == UIWebViewNavigationTypeLinkClicked)
	{
        [[UIApplication sharedApplication] openURL:request.URL];
        return false;
    }
	
    return true;
}

- (BOOL) shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void) didReceiveMemoryWarning
{
	[super didReceiveMemoryWarning];
}

@end
