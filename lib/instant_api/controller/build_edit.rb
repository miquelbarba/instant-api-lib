require 'instant_api/controller/build_new_edit'

module InstantApi::Controller
  class BuildEdit

    def initialize(controller, model_class_name = nil)
      @controller = controller
    end

    def build
      BuildNewEdit.new(@controller, 'edit').build
    end
  end
end