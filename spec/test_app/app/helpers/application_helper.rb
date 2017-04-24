module ApplicationHelper
  def app_foo &block
    "app_foo#{block.call if block_given?}"
  end
end
