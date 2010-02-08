class Currency < ActiveRecord::Base
  has_and_belongs_to_many :locales

  validates_presence_of :code, :name, :rate
  validates_numericality_of :rate

  def validate
    errors.add_to_base I18n.translate("only_one_default_currency") if self.default && Currency.exists?(["currencies.default = ? AND NOT currencies.id = ?" , true, self.id])
  end

  def symbol
    I18n.t 'number.currency.format.unit', :locale => self.locales.first.code.to_sym
  end
end
