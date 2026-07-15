class TaskStatusService
  def initialize(task, new_status)
    @task = task
    @new_status = new_status
  end

  def call
    return true if @task.status == @new_status
    return false unless valid_transition?

    @task.status = @new_status
    true
  end

  private

  def valid_transition?
    case @task.status
    when Task::STATUS_TO_DO
      check_transition([ Task::STATUS_IN_PROGRESS ], "статус To Do можно изменить только на In Progress")
    when Task::STATUS_IN_PROGRESS
      check_transition([ Task::STATUS_IN_TESTING, Task::STATUS_TO_DO ], "статус In Progress можно изменить только на In Testing или To Do")
    when Task::STATUS_IN_TESTING
      check_transition([ Task::STATUS_DONE, Task::STATUS_REJECTED ], "статус In Testing можно изменить только на Done или Rejected")
    when Task::STATUS_REJECTED
      check_transition([ Task::STATUS_IN_PROGRESS ], "статус Rejected можно изменить только на In Progress")
    when Task::STATUS_DONE
      check_transition([], "статус Done нельзя изменить")
    else
      false
    end
  end

  def check_transition(allowed_statuses, error_msg)
    if allowed_statuses.include?(@new_status)
      true
    else
      @task.errors.add(:status, error_msg)
      false
    end
  end
end
