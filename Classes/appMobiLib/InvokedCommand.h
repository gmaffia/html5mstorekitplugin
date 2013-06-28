
#import <Foundation/Foundation.h>

@interface InvokedCommand : NSObject {
	NSString* command;
	NSString* className;
	NSString* methodName;
	NSMutableArray* arguments;
	NSMutableDictionary* options;
}

@property(retain) NSMutableArray* arguments;
@property(retain) NSMutableDictionary* options;
@property(copy) NSString* command;
@property(copy) NSString* className;
@property(copy) NSString* methodName;

+ (InvokedCommand*) newFromUrl:(NSURL*)url;

- (void) dealloc;

@end
