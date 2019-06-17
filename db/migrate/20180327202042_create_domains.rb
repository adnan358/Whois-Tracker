class CreateDomains < ActiveRecord::Migration[5.1]
  def change
    create_table :domains do |t|
      t.references :user
      t.string :domain_name
      t.string :description
      t.string :description
      t.datetime :expire_time, null: false
      t.string :color
      t.string :job_id

      t.timestamps
    end
  end
end
