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

# WebPageObject is a base class for web viewers that represent a whole page. In addition to 
# all the normal features of a web viewer, a web page object has url or path, and can 
# navigate to the url or path using the load method.
class WebPageObject
  include BrowserInstance
  include WebViewer
  include WebPage
end
