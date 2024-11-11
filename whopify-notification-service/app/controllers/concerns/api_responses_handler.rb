module ApiResponsesHandler
  extend ActiveSupport::Concern

  def json_response(options = {}, status = 500)
    render json: JsonResponse.new(options), status:
  end

  def render_error_response(error, status = 422, message = "")
    json_response(
      {
        success: false,
        message:,
        errors: error
      },
      status
    )
  end

  def render_success_response(data: nil, message: "", status: 200, meta: {})
    json_response(
      {
        success: true,
        message:,
        data:,
        meta: meta_attributes(meta)
      },
      status
    )
  end

  def meta_attributes(collection, extra_meta = {})
    return nil if collection.blank?

    {
      pagination: {
        current_page: collection.current_page,
        next_page: collection.next_page,
        prev_page: collection.prev_page,
        total_pages: collection.total_pages,
        total_count: collection.total_count
      }
    }.merge(extra_meta)
  end
end
