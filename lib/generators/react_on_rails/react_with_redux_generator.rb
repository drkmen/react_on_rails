# frozen_string_literal: true

require "rails/generators"

module ReactOnRails
  module Generators
    class ReactWithReduxGenerator < Rails::Generators::Base
      include GeneratorHelper
      Rails::Generators.hide_namespace(namespace)
      source_root(File.expand_path("templates", __dir__))

      # --appname
      class_option :appname,
                   type: :string,
                   default: "hello_world",
                   desc: "Specify first component name"

      def create_redux_directories
        dirs = %w[actions constants containers reducers store startup]
        dirs.each { |name| empty_directory("app/javascript/bundles/#{file_class_name}/#{name}") }
      end

      def copy_base_files
        template("redux/base/app/javascript/bundles/App/components/component.jsx.erb",
                 "app/javascript/bundles/#{file_class_name}/components/#{file_class_name}.jsx")
      end

      def copy_base_redux_files
        base_hello_world_path = "redux/base/app/javascript/bundles/App"
        config = {
          file_name: file_name,
          file_class_name: file_class_name
        }
        %w[actions/actionCreators.js.erb
           containers/container.js.erb
           constants/constants.js.erb
           reducers/reducer.js.erb
           store/store.js.erb
           startup/app.jsx.erb].each do |file|
             file_path = file.split("/").first
             file_name = file.split("/").last.split('.')[0..1].join(".")
             full_file = file_class_name + file_name[0].upcase + file_name[1..-1]
             template"#{base_hello_world_path}/#{file}",
                     "app/javascript/bundles/#{file_class_name}/#{file_path}/#{full_file}", config
           end
      end

      def create_appropriate_templates
        base_path = "base/base"
        base_js_path = "#{base_path}/app/javascript"
        config = {
          component_name: "#{file_class_name}dApp",
          app_relative_path: "../bundles/#{file_class_name}/startup/#{file_class_name}App"
        }

        template "#{base_js_path}/packs/registration.js.tt",
                 "app/javascript/packs/#{file_variable_name}-bundle.js", config
        template "#{base_path}/app/views/hello_world/index.html.erb.tt",
                 "app/views/#{file_name}/index.html.erb", config
      end

      def add_redux_yarn_dependencies
        run "yarn add redux react-redux"
      end
    end
  end
end
