module ZhongwenTools
  [:Script].each do |sub_module|
    remove_const(sub_module)  if const_defined?(sub_module)
  end
end
