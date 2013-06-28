
#import "AppMobiDevice.h"
#import <SystemConfiguration/SCNetworkReachability.h>
#import "AppMobiDelegate.h"
#import "AppMobiModule.h"

@implementation AppMobiDevice

- (NSDictionary*)deviceProperties
{
	UIDevice *device = [UIDevice currentDevice];
	NSMutableDictionary *devProps = [NSMutableDictionary dictionaryWithCapacity:4];
	[devProps setObject:[NSString stringWithString:@"iOS"] forKey:@"platform"];
	[devProps setObject:[device systemVersion] forKey:@"version"];
	[devProps setObject:[device uniqueIdentifier] forKey:@"uuid"];
	[devProps setObject:[device model] forKey:@"model"];
	NSString *orientation;
	switch ([[UIApplication sharedApplication] statusBarOrientation]){
		case UIInterfaceOrientationPortrait:
			orientation = @"0";
			break;
		case UIInterfaceOrientationPortraitUpsideDown:
			orientation = @"180";
			break;
		case UIInterfaceOrientationLandscapeLeft:
			orientation = @"90";
			break;
		case UIInterfaceOrientationLandscapeRight:
			orientation = @"-90";
			break;
	}
	[devProps setObject:orientation forKey:@"initialOrientation"];
	[devProps setObject:[self getConnection] forKey:@"connection"];
	NSString *version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"];
	[devProps setObject:version forKey:@"appmobiversion"];
	
	NSDictionary *devReturn = [NSDictionary dictionaryWithDictionary:devProps];
	return devReturn;
}

- (NSString *)getConnection
{
	NSString *host = @"www.appmobi.com";
	SCNetworkReachabilityFlags flags;
	SCNetworkReachabilityRef reachability =  SCNetworkReachabilityCreateWithName(NULL, [host UTF8String]);
	SCNetworkReachabilityGetFlags(reachability, &flags);
	CFRelease(reachability);
	
	BOOL isReachable = (flags & kSCNetworkReachabilityFlagsReachable) == kSCNetworkReachabilityFlagsReachable;
	BOOL needsConnection = (flags & kSCNetworkReachabilityFlagsConnectionRequired) == kSCNetworkReachabilityFlagsConnectionRequired;
	BOOL noWifi = (flags & kSCNetworkReachabilityFlagsIsWWAN) == kSCNetworkReachabilityFlagsIsWWAN;
	
	if(isReachable && !needsConnection && !noWifi) return @"wifi";
	if(isReachable && !needsConnection && noWifi) return @"cell";
	return @"none";
}

- (void)registerLibrary:(NSMutableArray*)arguments withDict:(NSMutableDictionary*)options {
	NSString *library = (NSString *)[arguments objectAtIndex:0];
	
	if( library == nil || [library length] == 0 ) return;

	id obj = [[NSClassFromString(library) alloc] init];
	if( obj != nil && [obj isKindOfClass:[AppMobiModule class]]  )
	{
		[obj initialize:webView];
	}
}

@end
