
#import "IRubyNative.h"
#import "RubyNativeBase.h"

@interface RubyNative : RubyNativeBase<IRubyNative> {
}

-(void) getPlatformName:(id<IMethodResult>)methodResult;
-(void) calcSumm:(int)a b:(int)b methodResult:(id<IMethodResult>)methodResult;
-(void) joinStrings:(NSString*)a b:(NSString*)b methodResult:(id<IMethodResult>)methodResult;



@end