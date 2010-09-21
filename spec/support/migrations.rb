FileUtils.rm File.expand_path("../../scenario/db/*.sqlite3", __FILE__), :force => true
ActiveRecord::Base.logger = Logger.new(nil)
ActiveRecord::Migration.verbose = false
ActiveRecord::Migrator.migrate(File.expand_path("../../scenario/db/migrate/", __FILE__))