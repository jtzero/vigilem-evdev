# 
# fires after every example_group
module AfterEachExampleGroup
  def after_each_example_group?
    @after_each_example_group_flag ||= false
  end
  
  def after_each_example_group(&block)
    if block
      @after_each_example_group_flag = true
      @after_each_example_group = block
    else
      @after_each_example_group
    end
  end
end

RSpec.configure do |config|
  
  config.before :all do |example_group|
    if ((egc = example_group.class).respond_to? :after_each_example_group? and egc.after_each_example_group?)
      (egc.descendants - [egc]).map do |eg|
        eg.append_after(:context, &egc.after_each_example_group)
      end
    end
  end
  
  config.extend AfterEachExampleGroup
end
