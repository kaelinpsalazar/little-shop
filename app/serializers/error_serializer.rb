class ErrorSerializer
  def self.format_error(exception, status)
    error_object = {
      message: exception.message,
      errors: [
        {
          status: status.to_s,
          title: error_title(status),
          detail: exception.message
        }
      ]
    }

    error_object[:errors].unshift(error_object[:errors].first.to_json)

    error_object
  end

  private

  def self.error_title(status)
    case status
    when 404
      "Resource Not Found"
    when 422
      "Unprocessable Entity"
    when 400
      "Bad Request"
    else 
      "Error"
    end
  end
end