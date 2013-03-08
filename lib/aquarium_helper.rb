require 'aquarium'
include Aquarium::Aspects

module AquariumHelper
  def before(object, method, &block)
    Aspect.new :before, methods: [method], for_objects: [object] do |*args|
      block.call(args)
    end
  end

  def after(object, method, &block)
    Aspect.new :after, methods: [method], for_objects: [object] do |*args|
      block.call(args)
    end
  end

  def around(object, method, &block)
    Aspect.new :around, methods: [method], for_objects: [object] do |*args|
      jp = args[0]
      jp.proceed
      block.call(args)
    end
  end

  def before_all(object, &block)
    all_fns = object.class.instance_methods - Object.methods
    all_fns.each do |fn|
      Aspect.new :before, methods: [fn], for_objects: [object] do |*args|
        block.call(args)
      end
    end
  end

  def after_all(object, &block)
    all_fns = object.class.instance_methods - Object.methods
    all_fns.each do |fn|
      Aspect.new :after, methods: [fn], for_objects: [object] do |*args|
        block.call(args)
      end
    end
  end
end
