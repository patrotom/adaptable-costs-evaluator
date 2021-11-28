defmodule AdaptableCostsEvaluatorWeb.ApiSpec.Errors do
  require OpenApiSpex

  def all_errors() do
    [
      internal_server_error: internal_server_error(),
      not_found: not_found(),
      unprocessable_entity: unprocessable_entity()
    ]
  end

  def internal_errors() do
    [
      internal_server_error: internal_server_error(),
      not_found: not_found()
    ]
  end

  def internal_server_error do
    {"Internal server error", "application/json", __MODULE__.InternalServerError}
  end

  def not_found do
    {"Resource not found", "application/json", __MODULE__.NotFound}
  end

  def unprocessable_entity do
    {"Unprocessable input attributes", "application/json", __MODULE__.UnprocessableEntity}
  end

  defmodule InternalServerError do
    OpenApiSpex.schema(%{
      description: "Internal server error",
      type: :object,
      example: %{
        "errors" => %{
          "detail" => "Internal Server Error"
        }
      }
    })
  end

  defmodule NotFound do
    OpenApiSpex.schema(%{
      description: "Not found",
      type: :object,
      example: %{
        "errors" => %{
          "detail" => "Not Found"
        }
      }
    })
  end

  defmodule UnprocessableEntity do
    OpenApiSpex.schema(%{
      description: "Unprocessable entity",
      type: :object,
      example: %{
        "resource" => %{
          "attribute" => ["Error reason"]
        }
      }
    })
  end
end
