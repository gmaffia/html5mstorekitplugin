
#import "MyPluginSetup.h"
#import "JSON.h"
#import "AppMobiDelegate.h"

@implementation MyPluginSetup


- (NSDictionary*) initialize
{
	NSMutableDictionary *devProps = [NSMutableDictionary dictionaryWithCapacity:4];
	[devProps setObject:@"1" forKey:@"ready"];
	
	NSDictionary *devReturn = [NSDictionary dictionaryWithDictionary:devProps];
	return devReturn;
}

@end
