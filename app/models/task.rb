# typed: true

class Task < ApplicationRecord
  belongs_to :project

  STATUS_TO_DO = "to_do".freeze
  STATUS_IN_PROGRESS = "in_progress".freeze
  STATUS_IN_TESTING = "in_testing".freeze
  STATUS_DONE = "done".freeze
  STATUS_REJECTED = "rejected".freeze

  STATUSES = [
    STATUS_TO_DO,
    STATUS_IN_PROGRESS,
    STATUS_IN_TESTING,
    STATUS_DONE,
    STATUS_REJECTED
  ].freeze

  enum :status, {
    STATUS_TO_DO => "To Do",
    STATUS_IN_PROGRESS => "In Progress",
    STATUS_IN_TESTING => "In Testing",
    STATUS_DONE => "Done",
    STATUS_REJECTED => "Rejected"
  }

  validates :title, :description, presence: true
end
