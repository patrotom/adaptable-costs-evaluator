defmodule AdaptableCostsEvaluatorWeb.ApiSpec.Schemas do
  require OpenApiSpex

  alias OpenApiSpex.{Reference, Schema}
  alias AdaptableCostsEvaluatorWeb.ApiSpec.Attributes

  # Computation

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
        organization_id: Attributes.organization_id()
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
      description: "Request body of the Computation",
      type: :object,
      properties: %{
        computation: Computation
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
        data: %Schema{description: "List of Computations", type: :array, items: Computation}
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

  # Evaluator

  defmodule Evaluator do
    OpenApiSpex.schema(%{
      title: "Evaluator",
      description: """
      An Evaluator is the concrete implementation of a Formula evaluator that
      is capable of reading the definition of the Formula and evaluating it.

      The Evaluators can be created and manipulated only by the administrators.
      Other types of users can, however, read and list them.
      """,
      type: :object,
      properties: %{
        id: Attributes.id(),
        name: %Schema{type: :string, description: "Unique name of the Evaluator", maxLength: 100},
        description: %Schema{
          type: :string,
          description: "Description of the Evaluator",
          maxLength: 2000
        },
        module: %Schema{
          type: :string,
          description: "Name of the module that is implementing this Evaluator"
        }
      },
      required: [:id, :name, :module],
      exaple: %{
        "id" => 42,
        "name" => "Simple Evaluator",
        "description" => "This is a simple evaluator",
        "module" => "AdaptableCostsEvaluator.Evaluators.Implementations.SimpleEvaluator"
      }
    })
  end

  defmodule EvaluatorRequest do
    OpenApiSpex.schema(%{
      title: "Evaluator Request",
      description: "Request body of the Evaluator",
      type: :object,
      properties: %{
        evaluator: Evaluator
      },
      required: [:evaluator],
      example: %{
        "evaluator" => %{
          "name" => "Simple Evaluator",
          "description" => "This is a simple evaluator",
          "module" => "AdaptableCostsEvaluator.Evaluators.Implementations.SimpleEvaluator"
        }
      }
    })
  end

  defmodule EvaluatorResponse do
    OpenApiSpex.schema(%{
      title: "Evaluator Response",
      description: "Response body for a single Evaluator",
      type: :object,
      properties: %{
        data: Evaluator
      },
      example: %{
        "data" => %{
          "id" => 42,
          "name" => "Simple Evaluator",
          "description" => "This is a simple evaluator",
          "module" => "AdaptableCostsEvaluator.Evaluators.Implementations.SimpleEvaluator"
        }
      },
      "x-struct": __MODULE__
    })
  end

  defmodule EvaluatorsResponse do
    OpenApiSpex.schema(%{
      title: "Evaluators Response",
      description: "Response body for the multiple Evaluators",
      type: :object,
      properties: %{
        data: %Schema{description: "List of Evaluators", type: :array, items: Evaluator}
      },
      example: %{
        "data" => [
          %{
            "id" => 42,
            "name" => "Simple Evaluator",
            "description" => "This is a simple evaluator",
            "module" => "AdaptableCostsEvaluator.Evaluators.Implementations.SimpleEvaluator"
          }
        ]
      },
      "x-struct": __MODULE__
    })
  end

  # FieldSchema

  defmodule FieldSchema do
    OpenApiSpex.schema(%{
      title: "FieldSchema",
      description: """
      A FieldSchema is any JSON schema that can be used to validate a value
      of the Input or Output against.
      """,
      type: :object,
      properties: %{
        id: Attributes.id(),
        name: %Schema{
          type: :string,
          description: "Unique name of the FieldSchema",
          maxLength: 100
        },
        definition: %Schema{type: :object, description: "Valid JSON schema for the validation"}
      },
      required: [:id, :name, :definition],
      exaple: %{
        "id" => 42,
        "name" => "Integer",
        "definition" => %{
          "type" => "integer"
        }
      }
    })
  end

  defmodule FieldSchemaRequest do
    OpenApiSpex.schema(%{
      title: "FieldSchema Request",
      description: "Request body of the FieldSchema",
      type: :object,
      properties: %{
        field_schema: FieldSchema
      },
      required: [:field_schema],
      example: %{
        "field_schema" => %{
          "name" => "Integer",
          "definition" => %{
            "type" => "integer"
          }
        }
      }
    })
  end

  defmodule FieldSchemaResponse do
    OpenApiSpex.schema(%{
      title: "FieldSchema Response",
      description: "Response body for a single FieldSchema",
      type: :object,
      properties: %{
        data: FieldSchema
      },
      example: %{
        "data" => %{
          "id" => 42,
          "name" => "Integer",
          "definition" => %{
            "type" => "integer"
          }
        }
      },
      "x-struct": __MODULE__
    })
  end

  defmodule FieldSchemasResponse do
    OpenApiSpex.schema(%{
      title: "FieldSchemas Response",
      description: "Response body for the multiple FieldSchemas",
      type: :object,
      properties: %{
        data: %Schema{description: "List of FieldSchemas", type: :array, items: FieldSchema}
      },
      example: %{
        "data" => [
          %{
            "id" => 42,
            "name" => "Integer",
            "definition" => %{
              "type" => "integer"
            }
          }
        ]
      },
      "x-struct": __MODULE__
    })
  end

  # Formula

  defmodule Formula do
    OpenApiSpex.schema(%{
      title: "Formula",
      description: """
      A Formula represents an expression that that can be used inside the
      particular Computation. The syntax, behavior, and capability of the
      Formula definition depends on the linked Evaluator.
      """,
      type: :object,
      properties: %{
        id: Attributes.id(),
        name: %Schema{type: :string, description: "Name of the Formula", maxLength: 100},
        label: %Schema{
          type: :string,
          description:
            "Unique label of the Formula within the Computation that is used as a variable reference",
          pattern: ~r/^[a-zA-Z_$][a-zA-Z_$0-9]*$/,
          maxLength: 100
        },
        definition: %Schema{
          type: :string,
          description: "Definition of the Formula in the syntax supported by the linked Evaluator"
        },
        computation_id: Attributes.computation_id(),
        evaluator_id: %Schema{
          type: :integer,
          description: "ID of the Evaluator used to evaluate the definition of the Formula"
        }
      },
      required: [:id, :name, :label, :computation_id],
      example: %{
        "id" => 42,
        "name" => "Adder",
        "label" => "my_adder",
        "definition" => "input1 + 1",
        "computation_id" => 8,
        "evaluator_id" => 3
      }
    })
  end

  defmodule FormulaRequest do
    OpenApiSpex.schema(%{
      title: "Formula Request",
      description: "Request body of the Formula",
      type: :object,
      properties: %{
        formula: Formula
      },
      required: [:formula],
      example: %{
        "formula" => %{
          "name" => "Adder",
          "label" => "my_adder",
          "definition" => "input1 + 1",
          "evaluator_id" => 3
        }
      }
    })
  end

  defmodule FormulaResponse do
    OpenApiSpex.schema(%{
      title: "Formula Response",
      description: "Response body for a single Formula",
      type: :object,
      properties: %{
        data: Formula
      },
      example: %{
        "data" => %{
          "id" => 42,
          "name" => "Adder",
          "label" => "my_adder",
          "definition" => "input1 + 1",
          "computation_id" => 8,
          "evaluator_id" => 3
        }
      },
      "x-struct": __MODULE__
    })
  end

  defmodule FormulasResponse do
    OpenApiSpex.schema(%{
      title: "Formulas Response",
      description: "Response body for the multiple Formulas",
      type: :object,
      properties: %{
        data: %Schema{description: "List of Formulas", type: :array, items: Formula}
      },
      example: %{
        "data" => [
          %{
            "id" => 42,
            "name" => "Adder",
            "label" => "my_adder",
            "definition" => "input1 + 1",
            "computation_id" => 8,
            "evaluator_id" => 3
          }
        ]
      },
      "x-struct": __MODULE__
    })
  end

  defmodule FormulaEvaluationResponse do
    OpenApiSpex.schema(%{
      title: "Formula Evaluation Response",
      description: "Response body of the successful Formula evaluation",
      type: :object,
      properties: %{
        data: %Schema{
          type: :object,
          properties: %{
            result: %Schema{type: :object, description: "Value of the result in the JSON format"},
            affected_outputs: %Schema{
              type: :array,
              items: %Reference{"$ref": "#/components/schemas/Output"}
            }
          }
        }
      },
      example: %{
        "data" => %{
          "result" => 150,
          "affected_outputs" => [
            %{
              "id" => 42,
              "name" => "Total sum",
              "label" => "total_sum",
              "last_value" => 150,
              "field_schema_id" => 3,
              "formula_id" => 7
            }
          ]
        }
      },
      "x-struct": __MODULE__
    })
  end

  # Input

  defmodule Input do
    OpenApiSpex.schema(%{
      title: "Input",
      description: """
      An Input holds the input data provided by the client. The value of
      the Input is always validated against the linked FieldSchema. The
      Input can be seen as a variable which can hold data of the type
      determined by the linked FieldSchema.
      """,
      type: :object,
      properties: %{
        id: Attributes.id(),
        name: %Schema{type: :string, description: "Name of the Input", maxLength: 100},
        label: %Schema{
          type: :string,
          description:
            "Unique label of the Input within the Computation that is used as a variable reference",
          pattern: ~r/^[a-zA-Z_$][a-zA-Z_$0-9]*$/,
          maxLength: 100
        },
        last_value: %Schema{
          type: :object,
          description:
            "The most recent value of the Input that is valided against the linked FieldSchema"
        },
        computation_id: Attributes.computation_id(),
        field_schema_id: Attributes.field_schema_id()
      },
      required: [:id, :name, :label, :computation_id, :field_schema_id],
      example: %{
        "id" => 42,
        "name" => "Weight",
        "label" => "weight_input",
        "field_schema_id" => 3,
        "last_value" => 10
      }
    })
  end

  defmodule InputRequest do
    OpenApiSpex.schema(%{
      title: "Input Request",
      description: "Request body of the Input",
      type: :object,
      properties: %{
        input: Input
      },
      required: [:input],
      example: %{
        "input" => %{
          "name" => "Weight",
          "label" => "weight_input",
          "field_schema_id" => 3,
          "last_value" => 10
        }
      }
    })
  end

  defmodule InputResponse do
    OpenApiSpex.schema(%{
      title: "Input Response",
      description: "Response body for a single Input",
      type: :object,
      properties: %{
        data: Input
      },
      example: %{
        "data" => %{
          "id" => 42,
          "name" => "Weight",
          "label" => "weight_input",
          "field_schema_id" => 3,
          "last_value" => 10
        }
      },
      "x-struct": __MODULE__
    })
  end

  defmodule InputsResponse do
    OpenApiSpex.schema(%{
      title: "Inputs Response",
      description: "Response body for the multiple Inputs",
      type: :object,
      properties: %{
        data: %Schema{description: "List of Inputs", type: :array, items: Input}
      },
      example: %{
        "data" => [
          %{
            "id" => 42,
            "name" => "Weight",
            "label" => "weight_input",
            "field_schema_id" => 3,
            "last_value" => 10
          }
        ]
      },
      "x-struct": __MODULE__
    })
  end

  # Organization

  defmodule Organization do
    OpenApiSpex.schema(%{
      title: "Organization",
      description: """
      An Organization groups multiple Users together. The Users, within
      the Organization, can share the Computations together and collaborate
      together on their development.

      A User can be a member of the multiple Organizations. Each User has
      a Role within the Organization that determines the level of permissions
      to read and manipulate resources in the Organization.
      """,
      type: :object,
      properties: %{
        id: Attributes.id(),
        name: %Schema{type: :string, description: "Name of the Organization", maxLength: 100},
        username: %Schema{
          type: :string,
          description: "Unique username of the Organization",
          pattern: ~r/^[a-zA-Z0-9\.\_\-]+$/,
          maxLength: 100
        }
      },
      required: [:id, :name, :username],
      example: %{
        "id" => 42,
        "name" => "Engineers",
        "username" => "engineers"
      }
    })
  end

  defmodule OrganizationRequest do
    OpenApiSpex.schema(%{
      title: "Organization Request",
      description: "Request body of the Organization",
      type: :object,
      properties: %{
        organization: Organization
      },
      required: [:organization],
      example: %{
        "organization" => %{
          "name" => "Engineers",
          "username" => "engineers"
        }
      }
    })
  end

  defmodule OrganizationResponse do
    OpenApiSpex.schema(%{
      title: "Organization Response",
      description: "Response body for a single Organization",
      type: :object,
      properties: %{
        data: Organization
      },
      example: %{
        "data" => %{
          "id" => 42,
          "name" => "Engineers",
          "username" => "engineers"
        }
      },
      "x-struct": __MODULE__
    })
  end

  defmodule OrganizationsResponse do
    OpenApiSpex.schema(%{
      title: "Organizations Response",
      description: "Response body for the multiple Organizations",
      type: :object,
      properties: %{
        data: %Schema{description: "List of Organizations", type: :array, items: Organization}
      },
      example: %{
        "data" => [
          %{
            "id" => 42,
            "name" => "Engineers",
            "username" => "engineers"
          }
        ]
      },
      "x-struct": __MODULE__
    })
  end

  # Output

  defmodule Output do
    OpenApiSpex.schema(%{
      title: "Output",
      description: """
      An Output holds the result of the evaluation of the particular
      Formula. The value of the Output is always validated against the
      linked FieldSchema.
      """,
      type: :object,
      properties: %{
        id: Attributes.id(),
        name: %Schema{type: :string, description: "Name of the Output", maxLength: 100},
        label: %Schema{
          type: :string,
          description:
            "Unique label of the Output within the Computation that is used as a variable reference",
          pattern: ~r/^[a-zA-Z_$][a-zA-Z_$0-9]*$/,
          maxLength: 100
        },
        last_value: %Schema{
          type: :object,
          description:
            "The most recent value of the Output that is valided against the linked FieldSchema"
        },
        computation_id: Attributes.computation_id(),
        field_schema_id: Attributes.field_schema_id(),
        formula_id: Attributes.formula_id()
      },
      required: [:id, :name, :label, :computation_id, :field_schema_id],
      example: %{
        "id" => 42,
        "name" => "Total sum",
        "label" => "total_sum",
        "last_value" => 142,
        "field_schema_id" => 3,
        "formula_id" => 7
      }
    })
  end

  defmodule OutputRequest do
    OpenApiSpex.schema(%{
      title: "Output Request",
      description: "Request body of the Output",
      type: :object,
      properties: %{
        output: Output
      },
      required: [:output],
      example: %{
        "output" => %{
          "name" => "Total sum",
          "label" => "total_sum",
          "last_value" => 142,
          "field_schema_id" => 3,
          "formula_id" => 7
        }
      }
    })
  end

  defmodule OutputResponse do
    OpenApiSpex.schema(%{
      title: "Output Response",
      description: "Response body for a single Output",
      type: :object,
      properties: %{
        data: Output
      },
      example: %{
        "data" => %{
          "id" => 42,
          "name" => "Total sum",
          "label" => "total_sum",
          "last_value" => 142,
          "field_schema_id" => 3,
          "formula_id" => 7
        }
      },
      "x-struct": __MODULE__
    })
  end

  defmodule OutputsResponse do
    OpenApiSpex.schema(%{
      title: "Outputs Response",
      description: "Response body for the multiple Outputs",
      type: :object,
      properties: %{
        data: %Schema{description: "List of Outputs", type: :array, items: Output}
      },
      example: %{
        "data" => [
          %{
            "id" => 42,
            "name" => "Total sum",
            "label" => "total_sum",
            "last_value" => 142,
            "field_schema_id" => 3,
            "formula_id" => 7
          }
        ]
      },
      "x-struct": __MODULE__
    })
  end

  # Role

  defmodule Role do
    OpenApiSpex.schema(%{
      title: "Role",
      description: """
      The Roles are used within the Organization to determine what a
      User is able to do with the resources in the Organization.

      There are currently these Roles available:

      * owner
      * maintainer
      * regular
      """,
      type: :object,
      properties: %{
        type: %Schema{
          type: :string,
          description: "Type of the Role",
          enum: ["owner", "maintainer", "regular"]
        }
      },
      required: [:type],
      example: %{"type" => "maintainer"}
    })
  end

  defmodule RoleRequest do
    OpenApiSpex.schema(%{
      title: "Role Request",
      description: "Request body of the Role",
      type: :object,
      properties: %{
        role: Role
      },
      required: [:role],
      example: %{
        "role" => %{"type" => "maintainer"}
      }
    })
  end

  defmodule RoleResponse do
    OpenApiSpex.schema(%{
      title: "Role Response",
      description: "Response body for a single Role",
      type: :object,
      properties: %{
        data: Role
      },
      example: %{
        "data" => %{"type" => "maintainer"}
      },
      "x-struct": __MODULE__
    })
  end

  defmodule RolesResponse do
    OpenApiSpex.schema(%{
      title: "Roles Response",
      description: "Response body for the multiple Roles",
      type: :object,
      properties: %{
        data: %Schema{description: "List of Roles", type: :array, items: Role}
      },
      example: %{
        "data" => [
          %{"type" => "maintainer"}
        ]
      },
      "x-struct": __MODULE__
    })
  end

  # User

  defmodule User do
    OpenApiSpex.schema(%{
      title: "User",
      description: """
      A User represents a concrete user/account within the application.
      Most of the endpoints require authenticated User in order to work
      with them.
      """,
      type: :object,
      properties: %{
        id: Attributes.id(),
        first_name: %Schema{type: :string, description: "First name of the User", maxLength: 50},
        middle_name: %Schema{type: :string, description: "Middle name of the User", maxLength: 50},
        last_name: %Schema{type: :string, description: "Last name of the User", maxLength: 50},
        credential: %Schema{
          type: :object,
          properties: %{
            email: %Schema{
              type: :string,
              description: "Unique email of the User",
              pattern: ~r/^[^@]+@[^@]+$/
            },
            password: %Schema{type: :string, description: "Password of the User", minLength: 8}
          }
        }
      },
      required: [:id, :first_name, :last_name, :credential],
      example: %{
        "id" => 42,
        "first_name" => "John",
        "middle_name" => "von",
        "last_name" => "Smith",
        "credential" => %{
          "email" => "john.von.smith@example.com",
          "password" => "12345678"
        }
      }
    })
  end

  defmodule UserRequest do
    OpenApiSpex.schema(%{
      title: "User Request",
      description: "Request body of the User",
      type: :object,
      properties: %{
        user: User
      },
      required: [:user],
      example: %{
        "user" => %{
          "first_name" => "John",
          "middle_name" => "von",
          "last_name" => "Smith",
          "credential" => %{
            "email" => "john.von.smith@example.com",
            "password" => "12345678"
          }
        }
      }
    })
  end

  defmodule UserResponse do
    OpenApiSpex.schema(%{
      title: "User Response",
      description: "Response body for a single User",
      type: :object,
      properties: %{
        data: User
      },
      example: %{
        "data" => %{
          "id" => 42,
          "first_name" => "John",
          "middle_name" => "von",
          "last_name" => "Smith",
          "email" => "john.von.smith@example.com"
        }
      },
      "x-struct": __MODULE__
    })
  end

  defmodule UserTokenResponse do
    OpenApiSpex.schema(%{
      title: "User Token Response",
      description: "Response body for a single User with the token",
      type: :object,
      properties: %{
        data: User
      },
      example: %{
        "data" => %{
          "id" => 42,
          "first_name" => "John",
          "middle_name" => "von",
          "last_name" => "Smith",
          "email" => "john.von.smith@example.com",
          "token" =>
            "eyJhbGciOiJIUzUxMiIsInR5cCI6IkpXVCJ9.eyJhdWQiOiJBZGFwdGFibGUgQ29zdHMgRXZhbHVhdG9yIiwiZXhwIjoxNjQwNDM4NTk5LCJpYXQiOjE2MzgwMTkzOTksImlzcyI6IkFkYXB0YWJsZSBDb3N0cyBFdmFsdWF0b3IiLCJqdGkiOiJjZThhYTJkOC0zYWUxLTRiZjUtODBhYi1lYjE2NDUwZTZjYzciLCJuYmYiOjE2MzgwMTkzOTgsInN1YiI6IjUiLCJ0eXAiOiJhY2Nlc3MifQ.R1kaJMw7ZgFZEcMtgo2PCj7Lhg_AEfcwDRMTX4wTe1VJbuAnK3GzJPHGydSnuibezGNzndO4UdjqwsPhbj-ZJg"
        }
      },
      "x-struct": __MODULE__
    })
  end

  defmodule UsersResponse do
    OpenApiSpex.schema(%{
      title: "Users Response",
      description: "Response body for the multiple Users",
      type: :object,
      properties: %{
        data: %Schema{description: "List of Users", type: :array, items: User}
      },
      example: %{
        "data" => [
          %{
            "id" => 42,
            "first_name" => "John",
            "middle_name" => "von",
            "last_name" => "Smith",
            "email" => "john.von.smith@example.com"
          }
        ]
      },
      "x-struct": __MODULE__
    })
  end

  defmodule SignInRequest do
    OpenApiSpex.schema(%{
      title: "Sign-in Request",
      description: "Request body to sign in the User",
      type: :object,
      properties: %{
        data: %Schema{
          type: :object,
          properties: %{
            email: %Schema{
              type: :string,
              description: "Unique email of the User",
              pattern: ~r/^[^@]+@[^@]+$/
            },
            password: %Schema{type: :string, description: "Password of the User", minLength: 8}
          }
        }
      },
      example: %{
        "data" => %{
          "email" => "john.von.smith@example.com",
          "password" => "12345678"
        }
      },
      "x-struct": __MODULE__
    })
  end

  defmodule SignInResponse do
    OpenApiSpex.schema(%{
      title: "Sign-in Response",
      description: "Response after signing in the User",
      type: :object,
      properties: %{
        data: %Schema{
          type: :object,
          properties: %{
            token: %Schema{type: :string, description: "Bearer token"}
          }
        }
      },
      example: %{
        "data" => %{
          "token" =>
            "eyJhbGciOiJIUzUxMiIsInR5cCI6IkpXVCJ9.eyJhdWQiOiJBZGFwdGFibGUgQ29zdHMgRXZhbHVhdG9yIiwiZXhwIjoxNjQwNDM4NTk5LCJpYXQiOjE2MzgwMTkzOTksImlzcyI6IkFkYXB0YWJsZSBDb3N0cyBFdmFsdWF0b3IiLCJqdGkiOiJjZThhYTJkOC0zYWUxLTRiZjUtODBhYi1lYjE2NDUwZTZjYzciLCJuYmYiOjE2MzgwMTkzOTgsInN1YiI6IjUiLCJ0eXAiOiJhY2Nlc3MifQ.R1kaJMw7ZgFZEcMtgo2PCj7Lhg_AEfcwDRMTX4wTe1VJbuAnK3GzJPHGydSnuibezGNzndO4UdjqwsPhbj-ZJg"
        }
      },
      "x-struct": __MODULE__
    })
  end
end
