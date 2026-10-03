class AddUsername < ActiveRecord::Migration[4.2]
  def self.up
    add_column(:mail_messages, "username", :string, :null => false)
  end

  def self.down
    remove_column(:mail_messages, "username")
  end
end

