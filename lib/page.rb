require 'browser-instance'
require 'viewer'

module WebPage
  
  def self.included(target)
    super
    target.extend ClassMethods
  end
  
  def load
    if respond_to?(:url) 
      navigate.to_absolute(url) 
    elsif respond_to?(:path)
      navigate.to_relative(path) 
    end
    self
  end
  
  module ClassMethods
    
    def url(url_value)
      define_method(:url) { url_value }
    end
    
    def path(path_value)
      define_method(:path) { path_value }
    end
    
    def load
      new.load
    end
    
  end
  
end

class WebPageObject
  include BrowserInstance
  include WebViewer
  include WebPage
end
