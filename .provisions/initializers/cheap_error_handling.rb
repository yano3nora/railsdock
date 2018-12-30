# Cheap error handling.
# @see https://gist.github.com/yano3nora/3dadc56b5970a23a0528d9d4066b2110#cheap-error-handling

# Custom error classes.
class ForbiddenError < StandardError; end

# Handling exceptions at ErrorsController.
Rails.application.configure do
  config.exceptions_app = ->(env) { ErrorsController.action(:show).call(env) }
end

