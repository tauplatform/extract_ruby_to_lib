#include "../../../shared/generated/cpp/RubyNativeBase.h"

namespace rho {

using namespace apiGenerator;

class CRubyNativeImpl: public CRubyNativeBase
{
public:
    CRubyNativeImpl(const rho::String& strID): CRubyNativeBase()
    {
    }

    virtual void getPlatformName(rho::apiGenerator::CMethodResult& oResult) {
         oResult.set("UWP");
    }

    virtual void calcSumm( int a,  int b, rho::apiGenerator::CMethodResult& oResult) {
         oResult.set(a+b);
    }
    
    virtual void joinStrings( const rho::String& a,  const rho::String& b, rho::apiGenerator::CMethodResult& oResult) {
         oResult.set(a+b);
    }
};

class CRubyNativeSingleton: public CRubyNativeSingletonBase
{
    ~CRubyNativeSingleton(){}
    virtual rho::String getInitialDefaultID();
    virtual void enumerate(CMethodResult& oResult);
};

class CRubyNativeFactory: public CRubyNativeFactoryBase
{
    ~CRubyNativeFactory(){}
    virtual IRubyNativeSingleton* createModuleSingleton();
    virtual IRubyNative* createModuleByID(const rho::String& strID);
};

extern "C" void Init_RubyNative_extension()
{
    CRubyNativeFactory::setInstance( new CRubyNativeFactory() );
    Init_RubyNative_API();
}

IRubyNative* CRubyNativeFactory::createModuleByID(const rho::String& strID)
{
    return new CRubyNativeImpl(strID);
}

IRubyNativeSingleton* CRubyNativeFactory::createModuleSingleton()
{
    return new CRubyNativeSingleton();
}

void CRubyNativeSingleton::enumerate(CMethodResult& oResult)
{
    rho::Vector<rho::String> arIDs;
    arIDs.addElement("SC1");
    arIDs.addElement("SC2");

    oResult.set(arIDs);
}

rho::String CRubyNativeSingleton::getInitialDefaultID()
{
    CMethodResult oRes;
    enumerate(oRes);

    rho::Vector<rho::String>& arIDs = oRes.getStringArray();
        
    return arIDs[0];
}

}