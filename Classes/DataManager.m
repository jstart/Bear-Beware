/*
 This work is licensed under the Creative Commons Attribution-Share Alike 3.0 United States License. 
 To view a copy of this license, visit http://creativecommons.org/licenses/by-sa/3.0/us/ or 
 send a letter to Creative Commons, 171 Second Street, Suite 300, San Francisco, California, 94105, USA.
 
 Jed Laudenslayer
 http://kwigbo.com
 
 */

#import "DataManager.h"
#import <SystemConfiguration/SCNetworkReachability.h>
#include <netinet/in.h>

@interface DataManager (Private)

- (void) createLevels;

@end

@implementation DataManager

@synthesize currentlevel, levels, currentindex, misses, score, missed, defaults, playerName;

- (void) dealloc
{
	[playerName release];
	[defaults release];
	[levels release];
	[super dealloc];
}

-(id) init
{
	self = [super init];
	
	if (self)
	{
		defaults = [NSUserDefaults standardUserDefaults];
		
		[self createLevels];
	}
	
	return self;
}

- (void) createLevels
{	//Perfect 378
	NSArray *level1 = [NSArray arrayWithObjects:@"1", @"2", nil];
	NSArray *level2 = [NSArray arrayWithObjects:@"A", @"B", @"C", nil];
	NSArray *level3 = [NSArray arrayWithObjects:@"1", @"2", @"3", @"4", nil];
	NSArray *level4 = [NSArray arrayWithObjects:@"A", @"B", @"C", @"D", nil];
	NSArray *level5 = [NSArray arrayWithObjects:@"4", @"5", @"6", @"7", @"8", nil];
	NSArray *level6 = [NSArray arrayWithObjects:@"D", @"E", @"F", @"G", @"H", nil];
	NSArray *level7 = [NSArray arrayWithObjects:@"23", @"24", @"25", @"26", @"27", nil];
	NSArray *level8 = [NSArray arrayWithObjects:@"P", @"Q", @"R", @"S", @"T", @"U", @"V", nil];
	NSArray *level9 = [NSArray arrayWithObjects:@"55", @"56", @"57", @"58", @"59", @"60", @"61", nil];
	NSArray *level10 = [NSArray arrayWithObjects:@"A", @"B", @"C", @"D", @"E", @"F", @"G", @"H", nil];
	NSArray *level11 = [NSArray arrayWithObjects:@"14", @"15", @"16", @"17", @"18", @"19", @"20", @"21", nil];
	NSArray *level12 = [NSArray arrayWithObjects:@"Q", @"R", @"S", @"T", @"U", @"V", @"W", @"X", @"Y", @"Z", nil];
	NSArray *level13 = [NSArray arrayWithObjects:@"97", @"98", @"99", @"100", @"101", @"102", @"103", @"104", @"105", @"106", nil];
	NSArray *level14 = [NSArray arrayWithObjects:@"L", @"M", @"N", @"O", @"P", @"Q", @"R", @"S", @"T", @"U", @"V", nil];
	NSArray *level15 = [NSArray arrayWithObjects:@"97", @"98", @"99", @"100", @"101", @"102", @"103", @"104", @"105", @"106", nil];
	NSArray *level16 = [NSArray arrayWithObjects:@"D", @"E", @"F", @"G", @"H", @"I", @"J", @"K", @"L", @"M", @"N", @"O", @"P", nil];
	NSArray *level17 = [NSArray arrayWithObjects:@"100", @"101", @"102", @"103", @"104", @"105", @"106", @"107", @"108", @"109", @"110", @"111", @"112", nil];
	NSArray *level18 = [NSArray arrayWithObjects:@"C", @"D", @"E", @"F", @"G", @"H", @"I", @"J", @"K", @"L", @"M", @"N", @"O", @"P", @"Q", @"R", nil];
	NSArray *level19 = [NSArray arrayWithObjects:@"45", @"46", @"47", @"48", @"49", @"50", @"51", @"52", @"53", @"54", @"55", @"56", @"57", @"58", @"59", @"60", nil];
	NSArray *level20 = [NSArray arrayWithObjects:@"A", @"B", @"C", @"D", @"E", @"F", @"G", @"H", @"I", @"J", @"K", @"L", @"M", @"N", @"O", @"P", @"Q", @"R", nil];
	NSArray *level21 = [NSArray arrayWithObjects:@"202", @"203", @"204", @"205", @"206", @"207", @"208", @"209", @"210", @"211", @"212", @"213", @"214", @"215", @"216", @"217", @"218", @"219", nil];
	NSArray *level22 = [NSArray arrayWithObjects:@"E", @"F", @"G", @"H", @"I", @"J", @"K", @"L", @"M", @"N", @"O", @"P", @"Q", @"R", @"S", @"T", @"U", @"V", @"W", @"X", @"Y", @"Z", nil];
	NSArray *level23 = [NSArray arrayWithObjects:@"30", @"31", @"32", @"33", @"34", @"35", @"36", @"36", @"38", @"39", @"40", @"41", @"42", @"43", @"44", @"45", @"46", @"47", @"48", @"49", @"50", @"51", nil];
	NSArray *level24 = [NSArray arrayWithObjects:@"A", @"B", @"C", @"D", @"E", @"F", @"G", @"H", @"I", @"J", @"K", @"L", @"M", @"N", @"O", @"P", @"Q", @"R", @"S", @"T", @"U", @"V", @"W", @"X", @"Y", @"Z", nil];
	
	self.levels = [NSArray arrayWithObjects:level1, 
				   level2, level3, level4, level5, level6, level7, level8, 
				   level9, level10, level11, level12, level13, level14, 
				   level15, level16, level17, level18, level19, level20, level21, level22, level23, level24, nil];
}

- (BOOL) connectedToNetwork
{
    // Create zero addy
    struct sockaddr_in zeroAddress;
    bzero(&zeroAddress, sizeof(zeroAddress));
    zeroAddress.sin_len = sizeof(zeroAddress);
    zeroAddress.sin_family = AF_INET;
	
    // Recover reachability flags
    SCNetworkReachabilityRef defaultRouteReachability = SCNetworkReachabilityCreateWithAddress(NULL, (struct sockaddr *)&zeroAddress);
    SCNetworkReachabilityFlags flags;
	
    BOOL didRetrieveFlags = SCNetworkReachabilityGetFlags(defaultRouteReachability, &flags);
    CFRelease(defaultRouteReachability);
	
    if (!didRetrieveFlags)
    {
        NSLog(@"Error. Could not recover network reachability flags");
        return NO;
    }
	
    BOOL isReachable = flags & kSCNetworkFlagsReachable;
    BOOL needsConnection = flags & kSCNetworkFlagsConnectionRequired;
	BOOL nonWiFi = flags & kSCNetworkReachabilityFlagsTransientConnection;
	
	NSURL *testURL = [NSURL URLWithString:@"http://www.apple.com/"];
	NSURLRequest *testRequest = [NSURLRequest requestWithURL:testURL  cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:20.0];
	NSURLConnection *testConnection = [[NSURLConnection alloc] initWithRequest:testRequest delegate:self];
	
    return ((isReachable && !needsConnection) || nonWiFi) ? (testConnection ? YES : NO) : NO;
}

/////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////// Singleton ///////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////

static DataManager *sharedDataManager = nil;

+ (DataManager *) sharedManager
{
    @synchronized(self)
	{
        if (sharedDataManager == nil)
		{
            [[self alloc] init];
        }
    }
	
    return sharedDataManager;
}

+ (id)allocWithZone:(NSZone *)zone
{
    @synchronized(self)
	{
        if(sharedDataManager == nil)
		{
            sharedDataManager = [super allocWithZone:zone];
            return sharedDataManager;
        }
    }
	
    return nil;
}

- (id)copyWithZone:(NSZone *)zone
{	
    return self;
}

- (id) retain
{
    return self;
}

- (unsigned) retainCount
{
    return UINT_MAX;
}

- (void)release
{
	
}

- (id) autorelease
{
    return self;
}

@end
