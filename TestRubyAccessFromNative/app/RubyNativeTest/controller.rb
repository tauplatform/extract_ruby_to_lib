require 'rho/rhocontroller'
require 'helpers/application_helper'
require 'helpers/browser_helper'

class RubyNativeTestController < Rho::RhoController
  include BrowserHelper
  include ApplicationHelper
  
  def index
    render :back => '/app'
  end

  def run_test_get_platform
    objects = Rho::RubyNative.enumerate
    obj = objects[0]
    res = obj.getPlatformName
    Alert.show_popup "Rho::RubyNative.getPlatformName return : #{res.to_s}"
    render :action => :index, :back => '/app'
  end

  def run_test_calc_summ
    objects = Rho::RubyNative.enumerate
    obj = objects[0]
    res = obj.calcSumm(2,3) 
    Alert.show_popup "Rho::RubyNative.calcSumm(2,3) return : #{res.to_s}"
    render :action => :index, :back => '/app'
  end

  def run_test_join_strings
    objects = Rho::RubyNative.enumerate
    obj = objects[0]
    res = obj.joinStrings("aaa","bbb") 
    Alert.show_popup "Rho::RubyNative.joinStrings(aaa,bbb) return : #{res.to_s}"
    render :action => :index, :back => '/app'
  end

  
end
