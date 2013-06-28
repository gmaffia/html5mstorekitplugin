
#import "AppMobiViewController.h"
#import "AppMobiDelegate.h" 
#import "AppMobiWebView.h"

AppMobiViewController *master = nil;

@implementation AppMobiViewController

- (id) init
{
    self = [super init];
	master = self;
	return self;
}

+ (AppMobiViewController*)masterViewController
{
	return master;
}

- (AppMobiWebView *)getWebView
{
	return webView;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation) interfaceOrientation 
{
	return YES;
}

- (void)dealloc
{
	[webView release];
	[super dealloc];
}

- (void) loadView {
	CGRect frame = [[UIScreen mainScreen] applicationFrame];
	UIView *contentView = [[UIView alloc] initWithFrame:frame];
	contentView.autoresizingMask = (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight);
	self.view = contentView;
	self.view.backgroundColor = [UIColor clearColor];
	
	CGRect appFrame = [ [ UIScreen mainScreen ] applicationFrame];
	webView = [ [ AppMobiWebView alloc ] initWithFrame: CGRectMake( 0, 0, appFrame.size.width, appFrame.size.height ) ];
	webView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
	webView.backgroundColor = [UIColor clearColor];
	webView.opaque = NO;
	webView.scalesPageToFit = YES;
	[self.view addSubview:webView];
}

- (void) unloadView {
}

@end
