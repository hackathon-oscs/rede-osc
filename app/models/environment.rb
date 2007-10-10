# A Environment is like a website to be hosted in the platform. It may
# contain multiple Profile's and can be identified by several different
# domains.
class Environment < ActiveRecord::Base

  # returns the available features for a Environment, in the form of a
  # hash, with pairs in the form <tt>'feature_name' => 'Feature name'</tt>.
  def self.available_features
    {
      'some_feature' => _('Some feature'),
      'other_feature' => _('Other feature'),
    }
  end
  
  # #################################################
  # Relationships and applied behaviour
  # #################################################

  acts_as_design

  # One Environment can be reached by many domains
  has_many :domains, :as => :owner
  has_many :profiles

  has_many :categories
  has_many :display_categories, :class_name => 'Category', :conditions => 'display_color is not null and parent_id is null', :order => 'display_color'

  has_many :role_assignments, :as => 'resource'
  def superior_intances
    [self, nil]
  end
  # #################################################
  # Attributes
  # #################################################

  # store the Environment settings as YAML-serialized Hash.
  serialize :settings

  # returns a Hash containing the Environment configuration
  def settings
    self[:settings] ||= {}
  end
  
  # Enables a feature identified by its name
  def enable(feature)
    self.settings["#{feature}_enabled"] = true
  end

  # Disables a feature identified by its name
  def disable(feature)
    self.settings["#{feature}_enabled"] = false
  end

  # Tells if a feature, identified by its name, is enabled
  def enabled?(feature)
    self.settings["#{feature}_enabled"] == true
  end

  # enables the features identified by <tt>features</tt>, which is expected to
  # be an Enumarable object containing the identifiers of the desired features.
  # Passing <tt>nil</tt> is the same as passing an empty Array.
  def enabled_features=(features)
    features ||= []
    self.class.available_features.keys.each do |feature|
      if features.include? feature
        self.enable(feature)
      else
        self.disable(feature)
      end
    end
  end

  # the environment's terms of use: every user must accept them before
  # registering.
  def terms_of_use
    self.settings['terms_of_use']
  end

  # sets the environment's terms of use.
  def terms_of_use=(value)
    self.settings['terms_of_use'] = value
  end

  # returns <tt>true</tt> if this Environment has terms of use to be
  # accepted by users before registration.
  def has_terms_of_use?
    ! self.settings['terms_of_use'].nil?
  end
 
  # #################################################
  # Validations
  # #################################################

  # <tt>name</tt> is mandatory
  validates_presence_of :name

  # only one environment can be the default one
  validates_uniqueness_of :is_default, :if => (lambda do |environment| environment.is_default? end), :message => _('Only one Virtual Community can be the default one')

  validates_format_of :contact_email, :with => Noosfero::Constants::EMAIL_FORMAT, :if => (lambda { |record| ! record.contact_email.blank? })

  # #################################################
  # Business logic in general
  # #################################################

  # the default Environment.
  def self.default
    self.find(:first, :conditions => [ 'is_default = ?', true ] )
  end

  # returns an array with the top level categories for this environment. 
  def top_level_categories
    Category.top_level_for(self)
  end

  def default_hostname
    if self.domains(true).empty?
      'localhost.localdomain'
    else
      self.domains.find(:first, :order => 'id').name
    end
  end

end
