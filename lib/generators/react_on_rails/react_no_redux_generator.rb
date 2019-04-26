# frozen_string_literal: true

require "rails/generators"
require_relative "generator_helper"

module ReactOnRails
  module Generators
    class ReactNoReduxGenerator < Rails::Generators::Base
      include GeneratorHelper
      Rails::Generators.hide_namespace(namespace)
      source_root(File.expand_path("templates", __dir__))

      # --appname
      class_option :appname,
                   type: :string,
                   default: "hello_world",
                   desc: "Specify first component name"

      def copy_base_files
        file_class_name
        template("base/base/app/javascript/bundles/App/components/component.jsx.erb",
                 "app/javascript/bundles/#{file_class_name}/components/#{file_class_name}.jsx")
      end

      def create_appropriate_templates
        base_path = "base/base"
        config = {
          component_name: file_class_name,
          app_relative_path: "../bundles/#{file_class_name}/components/#{file_class_name}"
        }

        template("#{base_path}/app/javascript/packs/registration.js.tt",
                 "app/javascript/packs/#{file_variable_name}-bundle.js", config)
        template("#{base_path}/app/views/app/index.html.erb.tt",
                 "app/views/#{file_name}/index.html.erb", config)
      end
    end
  end
end
