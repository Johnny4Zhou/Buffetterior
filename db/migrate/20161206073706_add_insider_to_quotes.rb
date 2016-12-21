class AddInsiderToQuotes < ActiveRecord::Migration[5.0]
  def change
    add_column :quotes, :insider, :jsonb
  end
end
