package com.rho.rubynative;

import com.rhomobile.rhodes.api.RhoApiFactory;

public class RubyNativeFactory
        extends RhoApiFactory< RubyNative, RubyNativeSingleton>
        implements IRubyNativeFactory {

    @Override
    protected RubyNativeSingleton createSingleton() {
        return new RubyNativeSingleton(this);
    }

    @Override
    protected RubyNative createApiObject(String id) {
        return new RubyNative(id);
    }
}
