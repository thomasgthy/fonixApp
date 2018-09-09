class CreateMobileNumbers < ActiveRecord::Migration[5.1]
  def change
    create_table :mobile_numbers do |t|
      t.integer :mobile_number
      t.string :code
      t.string :ip_address
      t.timestamps
    end
  end
end
