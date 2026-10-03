class AllowNullUsername < ActiveRecord::Migration[7.2]
  # username is NULL when emails are received through rdm-mailhandler.rb
  def self.up
    change_column_null(:mail_messages, :username, true)
  end

  def self.down
    # Existing records may have a NULL username, so the constraint is not restored
  end
end
