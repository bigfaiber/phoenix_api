class FinancialStatus < ApplicationRecord
  belongs_to :fstatus, polymorphic: true
end
