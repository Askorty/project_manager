class Task < ApplicationRecord
  belongs_to :project

  validates :status, inclusion: { in: [ "To Do", "In Progress", "In Testing", "Rejected", "Done" ] }
  validates :title, :description, presence: true
  validate :check_status_transition

  def check_status_transition
    return unless status_changed?
    case status_was
    when "Done"
      errors.add(:status, "статус Done нельзя изменить")
    when "To Do"
      if status != "In Progress"
        errors.add(:status, "статус To Do можно изменить только на In Progress")
      end
    when "In Progress"
      if status != "In Testing" && status != "To Do"
        errors.add(:status, "статус In Progress можно изменить только на In Testing или To Do")
      end
    when "In Testing"
      if status != "Done" && status != "Rejected"
        errors.add(:status, "статус In Testing можно изменить только на Done или Rejected")
      end
    when "Rejected"
      if status != "In Progress"
        errors.add(:status, "статус Rejected можно изменить только на In Progress")
      end
    end
  end
end
