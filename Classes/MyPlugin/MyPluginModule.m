
#import "MyPluginModule.h"
#import "MyPluginSetup.h"
#import "MyPluginWorker.h"
#import "JSON.h"
#import "AppMobiWebView.h"

@implementation MyPluginModule

MyPluginSetup *mysetup = nil;
MyPluginWorker *myworker = nil;

- (void)setup:(AppMobiWebView*) webView
{
	mysetup = [[MyPluginSetup alloc] initWithWebView:webView];
	myworker = [[MyPluginWorker alloc] initWithWebView:webView];
	
	[webView registerCommand:mysetup forName:@"MyPluginSetup"];
	[webView registerCommand:myworker forName:@"MyPluginWorker"];	
}

- (void)initialize:(AppMobiWebView*) webView
{
	NSDictionary *props = [mysetup initialize];
	NSMutableString *result = [[NSMutableString alloc] initWithFormat:@"MyPluginInfo = %@;", [props JSONFragment]];

	[webView stringByEvaluatingJavaScriptFromString:[result stringByAppendingString:@"MyPluginLoaded();"]];
}

@end
