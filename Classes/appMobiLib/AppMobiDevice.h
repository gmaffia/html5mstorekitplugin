
#import <UIKit/UIKit.h>
#import <UIKit/UIDevice.h>
#import "AppMobiCommand.h"

@interface AppMobiDevice : AppMobiCommand {
}

- (NSDictionary*)deviceProperties;
- (NSString *)getConnection;

- (void)registerLibrary:(NSMutableArray*)arguments withDict:(NSMutableDictionary*)options;

@end
