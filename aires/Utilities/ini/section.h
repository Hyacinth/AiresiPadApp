#import <Foundation/Foundation.h>

@interface INISection : NSObject {

	NSMutableDictionary * assignments;
	NSString * sname;
}

- initWithName: (NSString *)name;
- (void)insert: (NSString *)name value: (NSString *)value;
- (NSString *)retrieve: (NSString *)name;

@end
