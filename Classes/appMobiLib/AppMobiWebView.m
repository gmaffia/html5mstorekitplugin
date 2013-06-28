#import "AppMobiWebView.h"
#import "AppMobiViewController.h"
#import "InvokedCommand.h"
#import "AppMobiModule.h"
#import "AppMobiDevice.h"
#import "JSON.h"

@implementation AppMobiWebView

- (void)initialize
{
	[super setDelegate:self];
	commandObjects = [[NSMutableDictionary alloc] initWithCapacity:4];

	//module support: register the commands for the modules listed in info.plist from bundle
	NSArray* modules = [NSMutableArray arrayWithArray:[[[NSBundle mainBundle] infoDictionary] objectForKey:@"modules"]];
	for (NSString* module in modules)
	{
		if( module == nil || [module length] == 0 ) continue;
		
		id obj = [[NSClassFromString(module) alloc] init];
		if( obj != nil && [obj isKindOfClass:[AppMobiModule class]]  )
		{
			[obj setup:self];
		}
	}
}

- (id)init
{
    if ((self = [super init]))
	{
		[self initialize];
	}
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    if ((self = [super initWithFrame:frame]))
	{
		[self initialize];
	}
    return self;
}

- (NSString *)appDirectory
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *basePath = ([paths count] > 0) ? [paths objectAtIndex:0] : nil;
    return basePath;
}

- (NSString *)baseDirectory
{
	return [[self appDirectory] stringByAppendingPathComponent:@"root"];
}

- (void)injectJS:(NSString *)js
{
	[self performSelectorOnMainThread:@selector(stringByEvaluatingJavaScriptFromString:) withObject:js waitUntilDone:NO];
}

- (BOOL)execute:(InvokedCommand*)command
{
	if (command.className == nil || command.methodName == nil) {
		return NO;
	}
	
	AppMobiCommand* obj = [self getCommandInstance:command.className];
	
	NSString* fullMethodName = [[NSString alloc] initWithFormat:@"%@:withDict:", command.methodName];
	if ([obj respondsToSelector:NSSelectorFromString(fullMethodName)]) {
		[obj performSelector:NSSelectorFromString(fullMethodName) withObject:command.arguments withObject:command.options];
	}
	else {
		NSLog(@"Class method '%@' not defined in class '%@'", fullMethodName, command.className);
		[NSException raise:NSInternalInconsistencyException format:@"Class method '%@' not defined against class '%@'.", fullMethodName, command.className];
	}
	[fullMethodName release];
	
	return YES;
}

- (void)registerCommand:(AppMobiCommand *)command forName:(NSString *)name
{
	[commandObjects setObject:command forKey:name];
}

-(id) getCommandInstance:(NSString*)className
{
    id obj = [commandObjects objectForKey:className];
    if( obj == nil )
	{
		obj = [[NSClassFromString(className) alloc] initWithWebView:self];
		[commandObjects setObject:obj forKey:className];
		[obj release];
    }
    return obj;
}

//--------------- UIWebViewDelegate methods

- (void)webViewDidStartLoad:(UIWebView *)theWebView 
{
	[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
}

- (void)webViewDidFinishLoad:(AppMobiWebView *)theWebView
{
	//inject javascript to initialize appMobi framework
	NSDictionary *deviceProperties = [[self getCommandInstance:@"AppMobiDevice"] deviceProperties];
	NSMutableString *result = [[NSMutableString alloc] initWithFormat:@"AppMobiInit = %@;", [deviceProperties JSONFragment]];
	
	NSLog(@"Device initialization: %@", result);
	[theWebView stringByEvaluatingJavaScriptFromString:result];
	[result release];
	
	[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
	
	//	webView = theWebView; 	
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    NSLog(@"Failed to load webpage with error: %@", [error localizedDescription]);
}

- (BOOL)webView:(UIWebView *)theWebView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
	NSURL *url = [request URL];
	NSLog(@"File URL %@", [url description]);
	
    if ([[url scheme] isEqualToString:@"appmobi"])
	{
		InvokedCommand* iuc = [[InvokedCommand newFromUrl:url] autorelease];
        [theWebView stringByEvaluatingJavaScriptFromString:@"AppMobi.queue.ready = true;"];
		[self execute:iuc];
		return NO;
	}
    else if ([url isFileURL])
    {
        return YES;
    }
	
	return YES;
}

//---

- (void)dealloc
{
	[commandObjects release];
    [super dealloc];
}
@end
