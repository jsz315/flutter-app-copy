#import "CopyappPlugin.h"
#if __has_include(<copyapp/copyapp-Swift.h>)
#import <copyapp/copyapp-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "copyapp-Swift.h"
#endif

@implementation CopyappPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftCopyappPlugin registerWithRegistrar:registrar];
}
@end
