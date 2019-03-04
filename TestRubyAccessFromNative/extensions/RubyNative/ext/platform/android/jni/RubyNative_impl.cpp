#include "rhodes.h"
#include "RubyNative.h"

#include "logging/RhoLog.h"
#undef DEFAULT_LOGCATEGORY
#define DEFAULT_LOGCATEGORY "RubyNative_impl"

#define RUBYNATIVE_FACTORY_CLASS "com.rho.rubynative.RubyNativeFactory"

extern "C" void Init_RubyNative_API(void);

extern "C" void Init_RubyNative(void)
{
    RAWTRACE(__FUNCTION__);

    JNIEnv *env = jnienv();
    if(env)
    {
        jclass cls = rho_find_class(env, RUBYNATIVE_FACTORY_CLASS);
        if(!cls)
        {
            RAWLOG_ERROR1("Failed to find java class: %s", RUBYNATIVE_FACTORY_CLASS);
            return;
        }
        jmethodID midFactory = env->GetMethodID(cls, "<init>", "()V");
        if(!midFactory)
        {
            RAWLOG_ERROR1("Failed to get constructor for java class %s", RUBYNATIVE_FACTORY_CLASS);
            return;
        }
        jobject jFactory = env->NewObject(cls, midFactory);
        if(env->IsSameObject(jFactory, NULL))
        {
            RAWLOG_ERROR1("Failed to create %s instance", RUBYNATIVE_FACTORY_CLASS);
            return;
        }
        
        RAWTRACE("Initializing Java factory");

        rho::CRubyNativeBase::setJavaFactory(env, jFactory);

        RAWTRACE("Deleting JNI reference");

        env->DeleteLocalRef(jFactory);

        RAWTRACE("Initializing API");

        Init_RubyNative_API();

        RAWTRACE("Init_RubyNative succeeded");
    }
    else
    {
        RAWLOG_ERROR("Failed to initialize RubyNative API: jnienv() is failed");
    }

}

extern "C" void Init_RubyNative_extension() {
    Init_RubyNative();
}
