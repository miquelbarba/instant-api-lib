require 'instant_api/controller/build_show'

module InstantApi::Controller
  class BuildEdit < BuildShow

    def initialize(controller, model_class_name = nil)
      @controller = controller
      @method = 'edit'
    end
  end
end