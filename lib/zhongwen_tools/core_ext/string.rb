require 'zhongwen_tools/string_extension'
ensure_module_defined = ->(base, module_name){
  base.const_set(module_name, Module.new) unless base.const_defined?(module_name)
}

ensure_module_defined[ZhongwenTools, :Romanization]
ensure_module_defined[ZhongwenTools, :StringExtension]
ensure_module_defined[ZhongwenTools, :Script]

String.send(:include, ZhongwenTools::StringExtension)
