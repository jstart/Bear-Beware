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
    }
	
	return self;
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
