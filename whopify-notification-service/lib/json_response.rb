# frozen_string_literal: true

class JsonResponse
  attr_reader :success, :message, :data, :meta, :errors

  def initialize(options = {})
    @success = options[:success]
    @message = options[:message] || ""
    @data = options[:data] || nil
    @meta = options[:meta] || nil
    @errors = options[:errors] || nil
  end

  def as_json(*)
    {
      success:,
      message:,
      data:,
      meta:,
      errors:
    }
  end
end
