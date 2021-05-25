FileUtils.rm File.expand_path("../../scenario/db/*.sqlite3", __FILE__), :force => true
ActiveRecord::Base.logger = Logger.new(nil)
ActiveRecord::Migration.verbose = false
ActiveRecord::MigrationContext.new(Rails.root.join('db', 'migrate'), ActiveRecord::SchemaMigration).migrate
