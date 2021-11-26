defmodule AdaptableCostsEvaluatorWeb.ApiSpec.Schemas do
  require OpenApiSpex

  alias OpenApiSpex.Schema
  alias AdaptableCostsEvaluatorWeb.ApiSpec.Attributes

  defmodule Computation do
    OpenApiSpex.schema(%{
      title: "Computation",
      description: """
      A Computation groups multiple Formulas, Inputs, and Outputs together
      in a form of a container. This resource can be compared to a spreadsheet
      in the conventional office programs.
      """,
      type: :object,
      properties: %{
        id: Attributes.id(),
        name: %Schema{type: :string, description: "Name of the Computation", maxLength: 100},
        creator_id: %Schema{
          type: :integer,
          description: "ID of the user who created the Computation"
        },
        organization_id: %Schema{
          type: :integer,
          description: "ID of the Organization the Computation is part of"
        }
      },
      required: [:id, :name, :creator_id],
      exaple: %{
        "id" => 42,
        "name" => "Fibonacci Solver",
        "creator_id" => 12,
        "organization_id" => 5
      }
    })
  end

  defmodule ComputationRequest do
    OpenApiSpex.schema(%{
      title: "Computation Request",
      description: "Request body for creating a new Computation",
      type: :object,
      properties: %{
        computation: %Schema{anyOf: [Computation]}
      },
      required: [:computation],
      example: %{
        "computation" => %{
          "name" => "Calculator",
          "organization_id" => 42
        }
      }
    })
  end

  defmodule ComputationResponse do
    OpenApiSpex.schema(%{
      title: "Computation Response",
      description: "Response body for a single Computation",
      type: :object,
      properties: %{
        data: Computation
      },
      required: [:computation],
      example: %{
        "data" => %{
          "id" => 42,
          "name" => "Calculator",
          "creator_id" => 12,
          "organization_id" => 5
        }
      },
      "x-struct": __MODULE__
    })
  end

  defmodule ComputationsResponse do
    OpenApiSpex.schema(%{
      title: "Computations Response",
      description: "Response body for the multiple Computations",
      type: :object,
      properties: %{
        data: %Schema{description: "List of computations", type: :array, items: Computation}
      },
      example: %{
        "data" => [
          %{
            "id" => 42,
            "name" => "Calculator",
            "creator_id" => 12,
            "organization_id" => 5
          }
        ]
      },
      "x-struct": __MODULE__
    })
  end
end
