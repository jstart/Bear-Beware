/*
 This work is licensed under the Creative Commons Attribution-Share Alike 3.0 United States License. 
 To view a copy of this license, visit http://creativecommons.org/licenses/by-sa/3.0/us/ or 
 send a letter to Creative Commons, 171 Second Street, Suite 300, San Francisco, California, 94105, USA.
 
 Jed Laudenslayer
 http://kwigbo.com
 
 */

#import <Foundation/Foundation.h>

@interface DataManager : NSObject
{
	int currentlevel;
	int currentindex;
	int score;
	int misses;
	BOOL missed;
	NSString *playerName;
	NSArray *levels;
	NSUserDefaults *defaults;
}

@property (readwrite) int currentlevel;
@property (readwrite) int currentindex;
@property (readwrite) int misses;
@property (readwrite) int score;
@property (readwrite) BOOL missed;

@property (nonatomic, retain) NSArray *levels;
@property (nonatomic, retain) NSUserDefaults *defaults;
@property (nonatomic, retain) NSString *playerName;

- (BOOL) connectedToNetwork;

+ (DataManager *) sharedManager;

@end