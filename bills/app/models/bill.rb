class Bill < ActiveRecord::Base
belongs_to :user

def sort_by_date
  self.bills.all.sort_by {|date| date[:due_date]}
end

end
