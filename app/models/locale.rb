class Locale < ActiveRecord::Base
  has_and_belongs_to_many :currencies

  validates_presence_of :code, :name

  def validate
    errors.add_to_base I18n.translate("only_one_default_locale") if self.default && Locale.exists?(["locales.default = ? AND NOT locales.id = ?" , true, self.id])
  end
end
