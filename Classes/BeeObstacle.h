//
//  Target.h
//  GameDemo
//
//  Created by Ronald Jett on 4/25/09.
//  http://morethanmachine.com/macdev
//	rlj3967@rit.edu
//

#import <Foundation/Foundation.h>
#import "chipmunk.h"

@interface BeeObstacle : NSObject {
	cpBody *targetBody;
	bool ready;
}
-(id) initWithCPBody: (cpBody *) bodyIn;
-(void) fireFromX: (float) x y:(float)y;
-(void) fireFromX: (float) x y:(float)y atSpeedX:(float)speedX atSpeedY:(float)speedY;
-(float) getY;
-(float) getX;
-(void) setSpeedX: (float) x;
-(void) setSpeedX: (float) x Y:(float)y;
-(void) resetPosition;
-(void) boundaryCheckLeft;
-(void) boundaryCheckRight;

@property(readwrite) bool ready;
@end
