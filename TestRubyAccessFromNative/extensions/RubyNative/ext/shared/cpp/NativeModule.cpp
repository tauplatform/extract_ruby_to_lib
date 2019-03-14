//
//  RubyNativeImpl.cpp

#include "NativeModule.h"
#include "logging/RhoLog.h"


#include "rhoruby/api/RhoRuby.h"

using namespace rho::ruby;

NativeModule::NativeModule() {
    
}

NativeModule::~NativeModule() {
    
}

rho::String NativeModule::test1() {
    
    // run ruby code in ruby thread
    IRhoRuby* rr = RhoRubySingletone::getRhoRuby();
    IObject* model1 = rr->makeRubyClassObject("Model1");
    IObject* result = rr->executeRubyObjectMethod(model1, "getAllItems", NULL);
    model1->release();
    
    // parse result
    IString* str_res = (IString*)result;
    const char* ttt = str_res->getUTF8();
    rho::String rs = ttt;
    str_res->release();
    
    return rs;
}

rho::String NativeModule::test2() {
    return "CPP result 02";
}

rho::String NativeModule::test3() {
    return "CPP result 03";
}
