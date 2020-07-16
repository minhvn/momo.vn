#import "MomoVnPlugin.h"
#if __has_include(<momo_vn/momo_vn-Swift.h>)
#import <momo_vn/momo_vn-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "momo_vn-Swift.h"
#endif

@implementation MomoVnPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftMomoVnPlugin registerWithRegistrar:registrar];
}
@end
