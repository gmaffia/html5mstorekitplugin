#import "AppMobiDelegate.h"
#import "AppMobiViewController.h"
#import <UIKit/UIKit.h>
#import "InvokedCommand.h"
#import "AppMobiDevice.h"
#import "AppMobiCommand.h"
#import "AppMobiModule.h"

AppMobiDelegate *sharedDelegate = nil;

@implementation AppMobiDelegate

@synthesize window;
@synthesize viewController;

- (id)init
{
	self = [super init];	
	if (self != nil) {
		sharedDelegate = self;	
	}

	return self; 
}

+ (AppMobiDelegate*)sharedDelegate
{
	return sharedDelegate;
}

+ (NSString *)rootDirectory
{
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *basePath = ([paths count] > 0) ? [paths objectAtIndex:0] : nil;
	return basePath;	
}

- (void) setupApplication
{
	NSString *rootDir = [AppMobiDelegate rootDirectory];
	NSString *baseDir = [rootDir stringByAppendingString:@"/_appMobi"];
	[[NSFileManager defaultManager] createDirectoryAtPath:baseDir withIntermediateDirectories:YES attributes:nil error:nil];
	
	NSString *bundleJS = [[NSBundle mainBundle] pathForResource:@"appmobi_iphone" ofType:@"js"];	
	NSString *moduleJS = [baseDir stringByAppendingFormat:@"/%@.js", @"appmobi"];
	[[NSFileManager defaultManager] removeItemAtPath:moduleJS error:nil];
	[[NSFileManager defaultManager] copyItemAtPath:bundleJS toPath:moduleJS error:nil];

	//module support: extract module javascripts listed in info.plist from bundle
	NSArray* jsToCopy = [NSMutableArray arrayWithArray:[[[NSBundle mainBundle] infoDictionary] objectForKey:@"javascripts"]];
	for (NSString* js in jsToCopy)
	{
		bundleJS = [[NSBundle mainBundle] pathForResource:js ofType:@"js"];
		moduleJS = [baseDir stringByAppendingFormat:@"/%@.js", js];
		
		[[NSFileManager defaultManager] removeItemAtPath:moduleJS error:nil];
		[[NSFileManager defaultManager] copyItemAtPath:bundleJS toPath:moduleJS error:nil];
	}

	bundleJS = [[NSBundle mainBundle] pathForResource:@"index" ofType:@"html"];	
	moduleJS = [rootDir stringByAppendingFormat:@"/%@.html", @"index"];
	[[NSFileManager defaultManager] removeItemAtPath:moduleJS error:nil];
	[[NSFileManager defaultManager] copyItemAtPath:bundleJS toPath:moduleJS error:nil];
	
	NSURL *appURL        = [NSURL fileURLWithPath:moduleJS];
	NSURLRequest *appReq = [NSURLRequest requestWithURL:appURL cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:5.0];
	[webView loadRequest:appReq];
}

- (void)applicationDidFinishLaunching:(UIApplication *)application
{
	CGRect screenBounds = [[UIScreen mainScreen] bounds];
	self.window = [[[UIWindow alloc] initWithFrame:screenBounds] autorelease];
	viewController = [[AppMobiViewController alloc] init];
	
	[window addSubview:viewController.view];
	webView = [viewController getWebView];
	[window makeKeyAndVisible];
	[self setupApplication];
}

- (void)applicationWillTerminate:(UIApplication *)application
{
}

- (void)dealloc
{
	[webView release];
	[viewController release];
	[window release];
	
	[super dealloc];
}

@end
