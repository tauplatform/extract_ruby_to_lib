//
//  RubyNativeImpl.cpp
#include "common/RhoStd.h"
#include "common/AutoPointer.h"
#include "common/RhodesApp.h"
#include "common/RhoConf.h"
#include "../generated/cpp/RubyNativeBase.h"
#include "logging/RhoLog.h"


#include "NativeModule.h"



namespace rho {
    
    using namespace apiGenerator;
    using namespace common;
    
    class CRubyNativeSingletonImpl: public CRubyNativeSingletonBase
    {
    public:
        
        CRubyNativeSingletonImpl(): CRubyNativeSingletonBase(){}
        
        //methods
        // test1 run test1 procedure 
        virtual void test1(rho::apiGenerator::CMethodResult& oResult) {
            // RAWLOGC_INFO("test1","RubyNative");
            NativeModule nm;
            oResult.set(nm.test1());
        } 
        // test2 run test2 procedure 
        virtual void test2(rho::apiGenerator::CMethodResult& oResult) {
            // RAWLOGC_INFO("test2","RubyNative");
            NativeModule nm;
            oResult.set(nm.test2());
        }
        // test3 run test3 procedure 
        virtual void test3(rho::apiGenerator::CMethodResult& oResult) {
            // RAWLOGC_INFO("test3","RubyNative");
            NativeModule nm;
            oResult.set(nm.test3());
        }

    };
    
    class CRubyNativeImpl : public CRubyNativeBase
    {
    public:
        virtual ~CRubyNativeImpl() {}

        //methods

    };
    
    ////////////////////////////////////////////////////////////////////////
    
    class CRubyNativeFactory: public CRubyNativeFactoryBase    {
    public:
        CRubyNativeFactory(){}
        
        IRubyNativeSingleton* createModuleSingleton()
        { 
            return new CRubyNativeSingletonImpl();
        }
        
        virtual IRubyNative* createModuleByID(const rho::String& strID){ return new CRubyNativeImpl(); };
        
    };
    
}

extern "C" void Init_RubyNative_extension()
{
    rho::CRubyNativeFactory::setInstance( new rho::CRubyNativeFactory() );
    rho::Init_RubyNative_API();
    
}
