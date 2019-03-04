using System;
using System.Collections.Generic;
using System.Net;
using System.Windows;
using System.Windows.Controls;
using System.Windows.Documents;
using System.Windows.Ink;
using System.Windows.Input;
using System.Windows.Media;
using System.Windows.Media.Animation;
using System.Windows.Shapes;
using rhoruntime;

namespace rho {

namespace RubyNativeImpl
{
    public class RubyNative : RubyNativeBase
    {
        public RubyNative(string id) : base(id)
        {
            // initialize class instance in C# here
        }

        public override void getSimpleStringProperty(IMethodResult oResult)
        {
            // implement this method in C# here
        }

        public override void setSimpleStringProperty(string simpleStringProperty, IMethodResult oResult)
        {
            // implement this method in C# here
        }

        public override void getPlatformName(IMethodResult oResult)
        {
            // implement this method in C# here
        }

        public override void calcSumm(int a, int b, IMethodResult oResult)
        {
            // implement this method in C# here
        }

        public override void joinStrings(string a, string b, IMethodResult oResult)
        {
            // implement this method in C# here
        }
    }

    public class RubyNativeSingleton : RubyNativeSingletonBase
    {
        public RubyNativeSingleton()
        {
            // initialize singleton instance in C# here
        }

        public override void enumerate(IMethodResult oResult)
        {
            // implement this method in C# here
        }
    }

    public class RubyNativeFactory : RubyNativeFactoryBase
    {
    }
}

}
