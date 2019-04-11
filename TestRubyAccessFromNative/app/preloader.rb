# Rhodes Preloader
#
# It can be advantageous to preload Rhodes:
#
# - requires
# - models
# - controller
#
# One advantage is that many run-time errors will then be caught very early, during
# application initialization.
#
# Rhodes normally loads modules - including database models - only on demand. Once
# loaded, they are never removed from memory. And, so, pre-loading may not be appropriate
# for all applications, or for all modules of all applications. If an app has many
# execution paths that will typically not be executed, the seldom-executed modules
# are not good candidates for pre-loading.
#
# It is ideal, though, for apps whose modules are typically used orthoganally, and
# the user will typically visit all or most execution paths during a use session.
#
# Pre-loading requires elminiates a lot of messy, redundant housekeeping, and
# gets modules always loaded in a specific, defined order.
#
# Pre-loading models solves some sticky chicken-and-egg scenarios brought on by
# the Rhom object factory and the fact that models are normally loaded on-demand.
# For example, you cannot obtain the source of a model in order to start a transaction
# until the model has been loaded.
#
# Pre-loading controllers can use use for reasons similar to requires. They get
# loaded in a known order, errors detected during load are detected early, and
# then it avoids delays on first use. (It moves those delays to app start-up, of course)
#
# This module contains a simple HTML error report, followed by log content, in case
# of error. So, many errors will be caught during QA when the application is first
# started, rather than waiting for QA or some user to happen to navigate a path that
# loads some module.
#

class String

  # Convert camelCase to snake_case
  def underscore
    self.gsub(/::/, '/').
    gsub(/([A-Z]+)([A-Z][a-z])/,'\1_\2').
    gsub(/([a-z\d])([A-Z])/,'\1_\2').
    tr("-", "_").
    downcase
  end
end


module Preloader


  # Global requires - get everything loaded up front so that we don't have
  # to hassle with sprinkling requires everywhere. As well, this gives us
  # an early opportunity to discover missing required files.
  REQUIRED_FILES = [
    'rho/rhoapplication',
    'library_extensions/log_extend',
    'library_extensions/network_extend',
    'library_extensions/rho_json_extend',
    'library_extensions/set_extend',
    'library_extensions/hash_extend',
    'library_extensions/string_extend',
    'library_extensions/time_extend',
    'library_extensions/webview_extend',
    'rho/rhocontroller',
    'set',
    'fileutils',
    'date',
    'time',
    'helpers/browser_helper',
    'helpers/request_helper',
    'helpers/ui_helper',
    'library_extensions/controller_extend',
    'model_mixins/base_model',
    'Settings/controller',
  ].freeze

  # These get loaded after models and controllers
  FINAL_REQUIRED_FILES = [
    'Model1/model1_controller',
  ]

  @@success = true
  @@failed_load_files = []          # These files failed to load, usually missing/misnamed file
  @@failed_during_load_files = []   # These files had some problem during load
  @@failed_models = []              # These models had some problem during load
  @@failed_controllers = []         # These controllers had some problem during load
  @@uninitialized_constants = []    # Unitialized constants found in the log

private

  # Non-dry so we do not depend on any require (duplicate of code in browser_helper.rb)
  def self.h(s)
    s.to_s.gsub(/&/, '&amp;').gsub(/\"/, '&quot;').gsub(/>/, '&gt;').gsub(/</, '&lt;').gsub(/\'/, '&apos;')
  end

  def self.log_info(msg)
    Rho::Log.info msg, self.to_s
  end

  def self.log_warning(msg)
    Rho::Log.warning msg, self.to_s
  end

  def self.log_newline
    self.log_info ''
  end

  def self.log_exception(e)
    Rho::Log.error "#{e.class.name}: #{e.to_s}", self.to_s
  end

  def self.preload_requires(files)
    self.log_newline
    self.log_info "Pre-loading common modules..."
    files.each do |file_name|
      begin
        require file_name
      # We MIGHT want to handle these types of error differently
      # We do not throw the error, so that we can continue to load additional files.
      # This may allow us to at least run to the point where we can display an error page.

      # LoadError will occur if the required file is not found.
      # Letting Rhodes handle this error would prematurely terminate application loading,
      # and there would be no possiblity of displaying an error page.
      # LoadError is not among the error types caught by bare 'rescue'. It must be
      # explicitly caught. (Or the collective ScriptError)
      rescue ScriptError => e
        @@success = false
        @@failed_load_files << file_name
        self.log_exception e

      # Some other error occured while loading the file. This will most likely
      # be a missing constant, due to an error while loading an included module,
      # or due to an included moudle not being present in REQUIRED_FILES.
      rescue StandardError => e
        @@success = false
        @@failed_during_load_files << file_name
        self.log_exception e

      end # begin

    end # REQUIRED_FILES.each
  end

  def self.preload_model(model_name)
    self.log_newline
    self.log_info "Pre-loading model: #{model_name}"
    require_source model_name
  end

  def self.load_seed_data(model_name)
    m = Kernel.const_get model_name
    count = m.find :count
    if count == 0
      m.load_seed_data
    end
  end

  # Define views
  # Define triggers
  # Load seed data
  # Used both at startup and after database reset
  def self.enhance_database
    sources = Rho::RhoConfig.sources
    # Define views
    # must preload all models before defining any views, becuase
    # some views might reference foreign tables
    # This load order is sufficient, so long as we don't get crazy
    # with views referencing views that haven't been defined yet!
    sources.each_key do |model_name|
      @@mn = model_name
      m = Kernel.const_get model_name
      m.define_views
    end  # sources.each

    # Define triggers
    # must preload all models and define all views before defining triggers,
    # becuase triggers might reference foreign tables and/or views
    sources.each_key do |model_name|
      @@mn = model_name
      m = Kernel.const_get model_name
      m.define_triggers
    end  #sources.each

    # Load seed data
    # Load seed data after all models, views, triggers defined, in case
    # loading seed data might trigger some trigger

    # Temporary hack: delete Translation table, in order to force reload
    # of seed data.
    # TODO: should rev schema version for Translation table when translation
    # seed data is changed in an app update, and then only when schema version
    # has changed, empty the table to force reload.
    Translation.delete_all

    sources.each_key do |model_name|
      @@mn = model_name
      self.load_seed_data model_name
    end  #sources.each
  end

  def self.preload_models
    # Then load all of our models, rather than waiting for Rhodes const_missing to
    # load them. Note that we cannot do this with 'require'. We need to use
    # require_source in order to invoke the Model object factory.
    self.log_newline
    self.log_info "Pre-loading all Models..."
    sources = Rho::RhoConfig.sources
    @@mn = ''

    begin

      # preload models
      sources.each_key do |model_name|
          @@mn = model_name
          self.preload_model model_name
      end  # sources.each

    # only for special prepared DB with special methods !!!
    #enhance_database

    # We rescue LoadError/SyntaxError during model load in case a require was
    # used in some code. While we require most modules above, we may still use
    # some explicit requires in code. Maybe we should parse the message and
    # add file name to failed load files in those cases?
    rescue ScriptError => e
      @@success = false
      @@failed_models << @@mn
      self.log_exception e
    rescue StandardError => e
      @@success = false
      @@failed_models << @@mn
      self.log_exception e
    end # begin

  end  # self.preload_models

  def self.preload_controllers
    self.log_newline
    self.log_info "Pre-loading all Controllers..."
    Rho::RhoConfig.sources.each_key do |model_name|
      model_path = Rho::Application.modelFolderPath model_name

      exists = false

      try_names = [ "#{model_name.underscore}_controller", "controller" ]
      try_exts = [ "#{RHO_RB_EXT}", "#{RHO_RB_EXT}#{RHO_ENCRYPTED_EXT}" ]
      controller_name = ''
      try_names.each do |name|
        try_exts.each do |ext|
          self.log_info "Trying controller file #{name}#{ext} for model #{model_name}"
          controller_name = name
          controller_path = Rho::RhoFile.join model_path, "#{name}#{ext}"
          exists = Rho::RhoFile.exists(controller_path)
          break if exists
        end
        break if exists
      end

      if !exists
        self.log_warning "Model #{model_name} does not have a controller"
      else
        begin
          require "#{model_name}/#{controller_name}"
        # We rescue LoadError/SyntaxError during model load in case a require was
        # used in some code. While we require most modules above, we may still use
        # some explicit requires in code. Maybe we should parse the message and
        # add file name to failed load files in those cases?
        rescue ScriptError => e
          @@success = false
          @@failed_controllers << model_name
          self.log_exception e
        rescue StandardError => e
          @@success = false
          @@failed_controllers << model_name
          self.log_exception e
        end # begin
      end
    end # Rho::RhoConfig::sources.each
  end

public
  def self.failed_load_files
    @@failed_load_files
  end

  def self.failed_during_load_files
    @@failed_during_load_files
  end

  def self.failed_models
    @@failed_models
  end

  def self.success
    @@success
  end

  def self.load
    self.preload_requires REQUIRED_FILES

      self.preload_models

      self.preload_controllers

    self.preload_requires FINAL_REQUIRED_FILES

    @@success
  end  # self.execute

  # Produces simple HTML summarizing any errors
  def self.error_html
    markup = <<-HERE
      <!DOCTYPE html>
      <meta charset='utf-8'/>
      <html>
        <head>
        <title>Preload Failure</title>

        <style>
          body {
            font-family: sans-serif;
          }

          li {
            font-family: monospace;
          }

          .error, .fail_list span {
            color: red;
          }
        </style>

        </head>
        <body>
          <h1>Application Pre-Load Failed</h1>
    HERE

    if !@@failed_load_files.empty?
      markup << <<-HERE
        <h2>Load Failures</h2>
        <p>(Usually, missing or mis-named required file)</p>
        <ol class="fail_list">
      HERE
      @@failed_load_files.each do |fn|
        markup << "<li><span>#{h fn}</span></li>"
      end
      markup << '</ol>'
    end

    if !@@failed_during_load_files.empty?
      markup << <<-HERE
        <h2>Failed During Load</h2>
        <p>(Usually, missing require or mis-ordered require)</p>
        <ol class="fail_list">
      HERE
      @@failed_during_load_files.each do |fn|
        markup << "<li><span>#{h fn}</span></li>"
      end
      markup << '</ol>'
    end

    if !@@failed_models.empty?
      markup << <<-HERE
        <h2>Errors While Loading Models</h2>
        <ol class="fail_list">
      HERE
      @@failed_models.each do |fn|
        markup << "<li><span>#{h fn}</span></li>"
      end
      markup << '</ol>'
    end

    if !@@failed_controllers.empty?
      markup << <<-HERE
        <h2>Errors While Loading Model Controllers</h2>
        <ol class="fail_list">
      HERE
      @@failed_controllers.each do |fn|
        markup << "<li><span>#{h fn}</span></li>"
      end
      markup << '</ol>'
    end

    log_markup = '<ol class="log_list">'
    Rho::Log.readLogFile(1000000).each_line do |line|
      has_error = line.start_with?('E') || line.start_with?('FATAL')
      css_class = has_error ? ' class="error"' : ''
      log_markup << "<li#{css_class}>#{self.h line}</span>"
      match_data = /NameError\: uninitialized constant (.*)/.match line
      if match_data
        uc = self.h(match_data[1])
        # Add to list of unitialized c/onstants if not previously encountered
        # Note the test for has_error. Rhodes creates an "info" message for stubbed
        # RhoConnect that matches our regexp.
        @@uninitialized_constants << uc if has_error && !@@uninitialized_constants.include?(uc)
      end
    end
    log_markup << '</ol>'

    if (!@@uninitialized_constants.empty?)
      markup << <<-HERE
        <h2>Uninitialized Constants (in order of first reference)</h2>
        <p>(Usually, module not loaded due to missing 'require')</p>
        <ol class="fail_list">
      HERE
      @@uninitialized_constants.each do |uc|
        markup << "<li><span>#{self.h uc}</span></li>"
      end
      markup << '</ol>'
    end

    markup << '<h2>Log</h2>'
    markup << log_markup

    markup << '</body></html>'

    markup
  end

end
