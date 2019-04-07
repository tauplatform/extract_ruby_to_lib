//
//  AccessToRhodes.cpp
//  RhoNativeIOS
//
//  Created by Dmitry Soldatenkov on 04/04/2019.
//  Copyright © 2019 TAU Technologies. All rights reserved.
//

#include "AccessToRhodes.hpp"



#include "rhoruby/api/RhoRuby.h"
#include "common/RhoStd.h"
#include "logging/RhoLog.h"


using namespace rho::ruby;


class CRubyNativeCallback : public IRubyNativeCallback {
    
    virtual void onRubyNative(IObject* param) {
        SmartPointer<IString> tr((IString*)param);
        const char* s = tr->getUTF8();
        int o = 0;
        o = 9;
        o = 10;
    }
    
};

rho::String rho_test1() {
    
    // run ruby code in ruby thread
    IRhoRuby* rr = RhoRubySingletone::getRhoRuby();
    IObject* model1 = rr->makeRubyClassObject("Model1");
    IObject* result = rr->executeRubyObjectMethod(model1, "getAllItems", NULL);
    model1->release();
    
    // parse result
    IArray* ar = (IArray*)result;
    rho::String str = "[ ";
    
    int i;
    for (i = 0; i < ar->getItemsCount(); i++) {
        IObject* item = ar->getItem(i);
        IString* attr1 = (IString*)rr->executeRubyObjectMethod(item, "attr1", NULL);
        IString* attr2 = (IString*)rr->executeRubyObjectMethod(item, "attr2", NULL);
        IString* attr3 = (IString*)rr->executeRubyObjectMethod(item, "attr3", NULL);
        
        str = str + "< attr1 = \""+attr1->getUTF8()+"\", attr2 = \""+attr2->getUTF8()+"\", attr3 = \""+attr3->getUTF8()+"\" >";
        
        if (i < (ar->getItemsCount()-1)) {
            str = str + ", ";
        }
        attr1->release();
        attr2->release();
        attr3->release();
    }
    str = str + " ]";
    result->release();
    
    return str;
}



rho::String rho_test2() {
    // run ruby code in ruby thread
    IRhoRuby* rr = RhoRubySingletone::getRhoRuby();
    IObject* model1 = rr->makeRubyClassObject("Model1");
    IObject* result;
    //result = rr->executeRubyObjectMethod(model1, "fillModelByPredefinedSet", NULL);
    //result->release();
    result = rr->executeRubyObjectMethod(model1, "getAllItemsAsHashes", NULL);
    model1->release();
    
    // parse result
    IArray* ar = (IArray*)result;
    rho::String str = "[ ";
    
    int i;
    for (i = 0; i < ar->getItemsCount(); i++) {
        IHash* item = (IHash*)ar->getItem(i);
        IString* attr1 = (IString*)item->getItem("attr1");
        IString* attr2 = (IString*)item->getItem("attr2");
        IString* attr3 = (IString*)item->getItem("attr3");
        
        str = str + "{ attr1 => \""+attr1->getUTF8()+"\", attr2 => \""+attr2->getUTF8()+"\", attr3 => \""+attr3->getUTF8()+"\" }";
        
        if (i < (ar->getItemsCount()-1)) {
            str = str + ", ";
        }

    }
    ar->release();
    str = str + " ]";

    
    return str;
}

rho::String rho_test3() {
    IRhoRuby* rr = RhoRubySingletone::getRhoRuby();
    rr->addRubyNativeCallback("myCallback01", new CRubyNativeCallback());
    SmartPointer<IObject> model1(rr->makeRubyClassObject("Model1"));
    
    SmartPointer<IMutableString> param((IMutableString*)rr->makeBaseTypeObject(BASIC_TYPES::MutableString));
    param->setUTF8("test UTF8 string from native");
    
    SmartPointer<IMutableArray> params((IMutableArray*)rr->makeBaseTypeObject(BASIC_TYPES::MutableArray));
    SmartPointer<IMutableString> param1((IMutableString*)rr->makeBaseTypeObject(BASIC_TYPES::MutableString));
    param1->setUTF8("param1_string");
    
    params->addItem(param1.getPointer());
    
    SmartPointer<IMutableHash> param2((IMutableHash*)rr->makeBaseTypeObject(BASIC_TYPES::MutableHash));
    
    SmartPointer<IMutableBoolean> param2_1((IMutableBoolean*)rr->makeBaseTypeObject(BASIC_TYPES::MutableBoolean));
    param2_1->setBool(true);
    param2->addItem("hashparam1_bool", param2_1.getPointer());
    
    SmartPointer<IMutableInteger> param2_2((IMutableInteger*)rr->makeBaseTypeObject(BASIC_TYPES::MutableInteger));
    param2_2->setLong(12345);
    param2->addItem("hashparam2_int", param2_2.getPointer());
    
    SmartPointer<IMutableFloat> param2_3((IMutableFloat*)rr->makeBaseTypeObject(BASIC_TYPES::MutableFloat));
    param2_3->setDouble(0.5f);
    param2->addItem("hashparam3_float", param2_3.getPointer());
    
    params->addItem(param2.getPointer());
    
    SmartPointer<IObject> result(rr->executeRubyObjectMethod(model1.getPointer(), "callNativeCallback", params.getPointer()));
    
    return "CPP result 03";
}



extern "C" void run_rho_test() {
    rho_test2();
}
