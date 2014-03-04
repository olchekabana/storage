# Load the rails application
require File.expand_path('../application', __FILE__)

# Initialize the rails application
Storage::Application.initialize!

ActiveSupport::Inflector.inflections do |inflect|
	inflect.uncountable "zakazchik", "archiveskdpd", "otdel_dfct", "stages_dog", "works_dog"
end