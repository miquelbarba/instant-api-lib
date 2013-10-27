require 'action_dispatch/routing/inspector'
require 'instant_api/controller/builder'

module InstantApi::Controller
  class Routes

    def initialize
      Rails.application.reload_routes!
      @routes = Rails.application.routes.routes.map do |route|
        ActionDispatch::Routing::RouteWrapper.new(route)
      end.reject(&:internal?)
    end

    def build_controllers
      controllers_by_routes = Hash.new
      @routes.each do |route|
        controller = route.defaults[:controller]
        list = controllers_by_routes[controller] || []
        controllers_by_routes[controller] = list << route
      end

      controllers = controllers_by_routes.map do |controller, routes|
        methods = routes.map { |route| route.defaults[:action] }
        [controller, methods]
      end

      controllers.each do |controller, methods|
        InstantApi::Controller::Builder.new(controller, methods).build_class
      end
    end
  end
end



=begin
routes.each do |route|
puts [ route.name,
       route.verb,
       route.path,
       route.reqs,
       route.defaults[:action],
       route.defaults[:controller],
       route.json_regexp].join(' - ')
end;nil
=end