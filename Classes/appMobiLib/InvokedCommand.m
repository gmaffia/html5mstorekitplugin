
#import "InvokedCommand.h"

@implementation InvokedCommand

@synthesize arguments;
@synthesize options;
@synthesize command;
@synthesize className;
@synthesize methodName;

+ (InvokedCommand*) newFromUrl:(NSURL*)url
{
	InvokedCommand* iuc = [[InvokedCommand alloc] init];
	
    iuc.command = [url host];
	
	NSString * fullUrl = [url description];
	int prefixLength = [[url scheme] length] + [@"://" length] + [iuc.command length] + 1;	int qsLength = [[url query] length];
	int pathLength = [fullUrl length] - prefixLength;

	// remove query string length
    if (qsLength > 0)
		pathLength = pathLength - qsLength - 1; // 1 is the "?" char
	// remove leading forward slash length
	else if ([fullUrl hasSuffix:@"/"] && pathLength > 0)
		pathLength -= 1; // 1 is the "/" char 
	
    NSString *path = [fullUrl substringWithRange:NSMakeRange(prefixLength, pathLength)];
	
	// Array of arguments
	NSMutableArray* arguments = [NSMutableArray arrayWithArray:[path componentsSeparatedByString:@"/"]];
	int i, arguments_count = [arguments count];
	for (i = 0; i < arguments_count; i++) {
		[arguments replaceObjectAtIndex:i withObject:[(NSString *)[arguments objectAtIndex:i]
													  stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
	}
	iuc.arguments = arguments;
    
	// Dictionary of options
	NSMutableDictionary* options = [NSMutableDictionary dictionaryWithCapacity:1];
	NSArray * options_parts = [NSArray arrayWithArray:[[url query] componentsSeparatedByString:@"&"]];
	int options_count = [options_parts count];
	
    for (i = 0; i < options_count; i++) {
		NSArray *option_part = [[options_parts objectAtIndex:i] componentsSeparatedByString:@"="];
		NSString *name = [(NSString *)[option_part objectAtIndex:0] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
		NSString *value = [(NSString *)[option_part objectAtIndex:1] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
		[options setObject:value forKey:name];
	}
	iuc.options = options;
	
	NSArray* components = [iuc.command componentsSeparatedByString:@"."];
	if (components.count == 2) {
		iuc.className = [components objectAtIndex:0];
		iuc.methodName = [components objectAtIndex:1];
	}		
	
	return iuc;
}

- (void) dealloc
{
	[arguments release];
	[options release];
	[command release];
	[className release];
	[methodName release];
	
	[super dealloc];
}

@end
