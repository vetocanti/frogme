require 'sequel'

module Database
  def self.connect(db_name)
    Sequel.sqlite(db_name)
  end

  def self.execute(db, query)
    db.run(query)
  end

  def self.close(db)
    db.disconnect
  end
end
