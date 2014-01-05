require 'instant_api/controller/exception_handler'
require 'instant_api/controller/build_create'
require 'instant_api/controller/build_destroy'
require 'instant_api/controller/build_edit'
require 'instant_api/controller/build_index'
require 'instant_api/controller/build_new'
require 'instant_api/controller/build_resource'
require 'instant_api/controller/build_update'
require 'instant_api/controller/build_show'

module InstantApi::Controller
  class Builder

    attr_reader :controller_name, :method_names
    def initialize(controller_name, method_names)
      @controller_name = controller_name

      @method_names = method_names.map(&:to_sym)
      @method_names << :resource if @method_names != [:index]
    end

    def build_class
      controller_class_name = "#{controller_name.camelize}Controller"
      controller = Class.new(ApplicationController)
      controller.send(:include, InstantApi::Controller::ExceptionHandler)
      build_methods(controller)

      Object.const_set(controller_class_name, controller)
    end

    private

    CLASSES = {
      create:   InstantApi::Controller::BuildCreate,
      destroy:  InstantApi::Controller::BuildDestroy,
      edit:     InstantApi::Controller::BuildEdit,
      update:   InstantApi::Controller::BuildUpdate,
      index:    InstantApi::Controller::BuildIndex,
      new:      InstantApi::Controller::BuildNew,
      show:     InstantApi::Controller::BuildShow,
      edit:     InstantApi::Controller::BuildEdit,
      resource: InstantApi::Controller::BuildResource
    }

    def build_methods(controller)
      model_class_name = controller_name.camelize.singularize
      method_names.each do |name|
        clasz = CLASSES[name]
        clasz.new(controller, model_class_name).build
      end
    end
  end
end