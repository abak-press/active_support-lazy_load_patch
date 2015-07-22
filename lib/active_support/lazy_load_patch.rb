require "active_support/lazy_load_hooks"
require "active_support/lazy_load_patch/version"

module ActiveSupport
  @load_hooks = Hash.new { |h,k| h[k] = [] }
  @loaded = Hash.new { |h,k| h[k] = [] }

  def self.on_load(name, options = {}, &block)
    @loaded[name].each do |base|
      execute_hook(base, options, block)
    end

    @load_hooks[name] << [block, options]
  end

  def self.execute_hook(base, options, block)
    if options[:yield]
      block.call(base)
    else
      base.instance_eval(&block)
    end
  end

  def self.run_load_hooks(name, base = Object)
    @loaded[name] << base
    @load_hooks[name].each do |hook, options|
      execute_hook(base, options, hook)
    end
  end
end
