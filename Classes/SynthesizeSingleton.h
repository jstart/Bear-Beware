//
//  Definition to realize singleton object
//  How to use it:
//      You should define class function with name format "+(<classname> *)shared<classname>" and then you will be able to use it to initialize and use singletone object of <classname> class in your code;
//      
//

#define SYNTHESIZE_SINGLETON_FOR_CLASS(classname) \
 \
static classname *shared##classname = nil; \
 \
+ (classname *)shared##classname \
{ \
	@synchronized(self) \
	{ \
		if (shared##classname == nil) \
		{ \
			shared##classname = [[self alloc] init]; \
		} \
	} \
	 \
	return shared##classname; \
} \
 \
+ (id)allocWithZone:(NSZone *)zone \
{ \
	@synchronized(self) \
	{ \
		if (shared##classname == nil) \
		{ \
			shared##classname = [super allocWithZone:zone]; \
			return shared##classname; \
		} \
	} \
	 \
	return nil; \
} \
 \
- (id)copyWithZone:(NSZone *)zone \
{ \
	return self; \
} \
 \
- (id)retain \
{ \
	return self; \
} \
 \
- (NSUInteger)retainCount \
{ \
	return NSUIntegerMax; \
} \
 \
- (oneway void)release \
{ \
} \
 \
- (id)autorelease \
{ \
	return self; \
}
