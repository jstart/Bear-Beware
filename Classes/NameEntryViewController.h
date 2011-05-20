/*
 This work is licensed under the Creative Commons Attribution-Share Alike 3.0 United States License. 
 To view a copy of this license, visit http://creativecommons.org/licenses/by-sa/3.0/us/ or 
 send a letter to Creative Commons, 171 Second Street, Suite 300, San Francisco, California, 94105, USA.
 
 Jed Laudenslayer
 http://kwigbo.com
 
 */

#import <UIKit/UIKit.h>
#import "DataManager.h"

@interface NameEntryViewController : UIViewController
{
	IBOutlet UITextField *nameField;
	UIActivityIndicatorView *activityIndicator;
	
	IBOutlet UIBarButtonItem *cancel_btn;
	DataManager *dataManager;
}

@property (nonatomic, retain) UITextField *nameField;
@property (nonatomic, retain) UIBarButtonItem *cancel_btn;
@property (nonatomic, retain) DataManager *dataManager;
@property (nonatomic, retain) UIActivityIndicatorView *activityIndicator;

- (IBAction) cancel;
- (void) submitScore;

@end
