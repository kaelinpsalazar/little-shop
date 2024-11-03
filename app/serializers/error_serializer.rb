class ErrorSerializer
  def self.format_error(exception, status)
    {
      errors: [
        {
          status: status.to_s,
          title: error_title(status),
          detail: exception.message
        }
      ]
    }
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