class CreateQuotes < ActiveRecord::Migration[5.0]
  def change
    create_table :quotes do |t|
      t.string :symbol
      t.string :name
      t.string :exchange
      t.jsonb :financials

      t.timestamps
    end
  end
end
