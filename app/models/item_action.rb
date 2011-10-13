class ItemAction < ActiveRecord::Base
  belongs_to :user
  belongs_to :actionable, :polymorphic => true
end
