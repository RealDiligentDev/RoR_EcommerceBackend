class CreateRecoveryKeys < ActiveRecord::Migration[7.2]
  def change
    create_table :recovery_keys do |t|
      t.references :user, null: false, foreign_key: true
      t.string :key

      t.timestamps
    end
  end
end
