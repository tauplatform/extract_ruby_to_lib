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
    }
    str = str + " ]";
    result->release();
   
    return str;
}



rho::String NativeModule::test2() {
    // run ruby code in ruby thread
    IRhoRuby* rr = RhoRubySingletone::getRhoRuby();
    IObject* model1 = rr->makeRubyClassObject("Model1");
    IObject* result = rr->executeRubyObjectMethod(model1, "getAllItemsAsHashes", NULL);
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
    str = str + " ]";
    result->release();
    
    return str;
}

rho::String NativeModule::test3() {
    return "CPP result 03";
}
