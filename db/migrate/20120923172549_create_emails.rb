class CreateEmails < ActiveRecord::Migration
  def change
    create_table :emails do |t|
      t.text :contents

      t.timestamps
    end
  end
end
