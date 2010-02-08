class CreateCurrenciesLocales < ActiveRecord::Migration
  def self.up
     create_table :currencies_locales, :id => false  do |t|
       t.references :currency
       t.references :locale
     end
  end

  def self.down
    drop_table :currencies_locales
  end
end
