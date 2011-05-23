module Paranoia
  def self.included(klazz)
    klazz.extend Query
  end

  module Query
    def paranoid? ; true ; end
  end

  def destroy
    _run_destroy_callbacks
    self[:deleted_at] ||= Time.now
    self.save(:validate => false)
    self.freeze
  end
  alias :delete :destroy

  def destroyed?
    !self[:deleted_at].nil?
  end
  alias :deleted? :destroyed?
end

class ActiveRecord::Base
  def self.acts_as_paranoid
    self.send(:include, Paranoia)
    default_scope :conditions => { :deleted_at => nil }
  end

  def self.paranoid? ; false ; end
  def paranoid? ; self.class.paranoid? ; end
end
