# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     AdaptableCostsEvaluator.Repo.insert!(%AdaptableCostsEvaluator.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

alias AdaptableCostsEvaluator.Repo

# Users
attrs = %{
  credential: %{
    email: "admin@example.com",
    password: "12345678"
  },
  first_name: "John",
  last_name: "Smith",
  admin: true
}

user =
  %AdaptableCostsEvaluator.Users.User{}
  |> AdaptableCostsEvaluator.Users.change_user(attrs)
  |> Ecto.Changeset.cast_assoc(:credential,
    with: &AdaptableCostsEvaluator.Users.Credential.changeset/2
  )
  |> Repo.insert!()

# Evaluators
evaluator =
  %AdaptableCostsEvaluator.Evaluators.Evaluator{
    description: "This is a simple evaluator",
    module: "AdaptableCostsEvaluator.Evaluators.Implementations.SimpleEvaluator",
    name: "Simple Evaluator"
  }
  |> Repo.insert!()

# FieldSchemas
alias AdaptableCostsEvaluator.FieldSchemas.FieldSchema

integer_fs =
  %FieldSchema{
    definition: %{
      type: "integer"
    },
    name: "Integer"
  }
  |> Repo.insert!()

number_fs =
  %FieldSchema{
    definition: %{
      type: "number"
    },
    name: "Number"
  }
  |> Repo.insert!()

boolean_fs =
  %FieldSchema{
    definition: %{
      type: "boolean"
    },
    name: "Boolean"
  }
  |> Repo.insert!()

# Organizations
organization =
  %AdaptableCostsEvaluator.Organizations.Organization{
    name: "Engineers",
    username: "engineers"
  }
  |> Repo.insert!()

membership =
  %AdaptableCostsEvaluator.Organizations.Membership{
    user_id: user.id,
    organization_id: organization.id
  }
  |> Repo.insert!()

%AdaptableCostsEvaluator.Organizations.Role{
  type: :owner,
  membership_id: membership.id
}
|> Repo.insert!()

# Computations
computation =
  %AdaptableCostsEvaluator.Computations.Computation{
    name: "BMI Calculator",
    creator_id: user.id,
    organization_id: organization.id
  }
  |> Repo.insert!()

# Inputs
alias AdaptableCostsEvaluator.Inputs.Input

weight =
  %Input{
    computation_id: computation.id,
    field_schema_id: number_fs.id,
    label: "weight_input",
    last_value: 75.8,
    name: "Weight in kg"
  }
  |> Repo.insert!()

height =
  %Input{
    computation_id: computation.id,
    field_schema_id: number_fs.id,
    label: "height_input",
    last_value: 172.5,
    name: "Height in cm"
  }
  |> Repo.insert!()

# Formulas
bmi_formula =
  %AdaptableCostsEvaluator.Formulas.Formula{
    computation_id: computation.id,
    definition: "(#{weight.label} / #{height.label} / #{height.label}) * 10000",
    evaluator_id: evaluator.id,
    label: "bmi_formula",
    name: "BMI Formula"
  }
  |> Repo.insert!()

# Outputs
bmi_output =
  %AdaptableCostsEvaluator.Outputs.Output{
    computation_id: computation.id,
    field_schema_id: number_fs.id,
    formula_id: bmi_formula.id,
    label: "bmi_output",
    name: "BMI"
  }
  |> Repo.insert!()
