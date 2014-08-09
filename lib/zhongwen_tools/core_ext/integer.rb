require 'zhongwen_tools/integer_extension'
ensure_module_defined = ->(base, module_name){
  base.const_set(module_name, Module.new) unless base.const_defined?(module_name)
}
ensure_module_defined[ZhongwenTools, :Number]
ensure_module_defined[ZhongwenTools, :IntegerExtension]

Integer.send(:include, ZhongwenTools::IntegerExtension)
