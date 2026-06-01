# ServiceResult — a lightweight value object returned by every service.
#
# Every service in the application returns a ServiceResult instance.
# This gives controllers a consistent interface regardless of which
# service they call:
#
#   result = Articles::CreateService.call(user, params)
#
#   if result.success?
#     redirect_to result.record
#   else
#     @article = result.record
#     @errors  = result.errors
#     render :new
#   end
#
# Benefits over returning true/false or raising exceptions:
#   - Controllers branch on result.success? — clean and readable
#   - result.record always returns the affected model for re-rendering forms
#   - result.errors carries human-readable messages for display
#   - No exceptions used for control flow — exceptions are for
#     unexpected failures, not expected business rule violations
#   - Every service has the same contract — no surprise return types

class ServiceResult
  attr_reader :record, :errors

  def initialize(success:, record: nil, errors: [])
    @success = success
    @record  = record
    @errors  = Array(errors)
  end

  def success?
    @success
  end

  def failure?
    !@success
  end

  # Convenience constructors — services use these instead of
  # calling ServiceResult.new directly:
  #
  #   return ServiceResult.ok(record: @article)
  #   return ServiceResult.fail(record: @article, errors: @article.errors.full_messages)

  def self.ok(record: nil)
    new(success: true, record: record)
  end

  def self.fail(record: nil, errors: [])
    new(success: false, record: record, errors: errors)
  end
end
