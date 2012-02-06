//
//  target.m
//  GameDemo
//

#import "BeeObstacle.h"


@implementation BeeObstacle
-(id) initWithCPBody: (cpBody *) bodyIn
{
	self = [super init];
	if(self != nil){
		targetBody = bodyIn;
		ready = YES;
	}
	
	return self;
}
-(void) fireFromX: (float) x y:(float)y
{
	targetBody->p = cpv(x,y);
	targetBody->v = cpv(0, -50);
}
-(void) setSpeedX: (float) x
{
	targetBody->v = cpv(x,-100);
}
-(void) setSpeedX: (float) x Y:(float)y
{
	targetBody->v = cpv(x,y);
}
-(void) fireFromX: (float) x y:(float)y atSpeedX:(float)speedX atSpeedY:(float)speedY
{
	targetBody->p = cpv(x,y);
	targetBody->v = cpv(speedX, speedY);
}
-(float) getY
{
	return targetBody->p.y;
}
-(float) getX
{
	return targetBody->p.x;
}
-(void) resetPosition
{
	targetBody->p = cpv(160,-40);
	targetBody->v = cpv(0,-50);
}
-(void) boundaryCheckLeft
{
	targetBody->p = cpv(35,35);
}
-(void) boundaryCheckRight
{
	targetBody->p = cpv(285,35);
}
@synthesize ready;
@end
