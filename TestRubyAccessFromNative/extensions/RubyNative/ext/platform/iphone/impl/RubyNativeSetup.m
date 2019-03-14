#import <Foundation/Foundation.h>
#include "common/app_build_capabilities.h"

extern void Init_RubyNative_API();

void Init_RubyNative_extension()
{
    Init_RubyNative_API();
}
