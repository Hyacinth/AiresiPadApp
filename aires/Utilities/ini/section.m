#import "section.h"

@implementation INISection

- initWithName: (NSString *)name {

	self = [super init];
	assignments = [[NSMutableDictionary alloc] init];
	sname = name;
	return self;
}

- (void)insert: (NSString *)name value: (NSString *)value {

	[assignments setObject: value forKey: name];
	return;
}

- (NSString *)retrieve: (NSString *)name {
	NSString * ret;

	ret = [assignments objectForKey: name];
	return ret;
}

@end
