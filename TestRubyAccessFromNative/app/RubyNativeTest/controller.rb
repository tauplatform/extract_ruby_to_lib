require 'rho/rhocontroller'
require 'helpers/application_helper'
require 'helpers/browser_helper'

class RubyNativeTestController < Rho::RhoController
  include BrowserHelper
  include ApplicationHelper

  def index
    render :back => '/app'
  end

  def run_test1
    res = Rho::RubyNative.test1
    Alert.show_popup "test1 return : #{res.to_s}"
    render :action => :index, :back => '/app'
  end

  def run_test2
      res = Rho::RubyNative.test2
      Alert.show_popup "test2 return : #{res.to_s}"
      render :action => :index, :back => '/app'
  end

  def run_test3
      res = Rho::RubyNative.test3
      Alert.show_popup "test3 return : #{res.to_s}"
      render :action => :index, :back => '/app'
  end


end
