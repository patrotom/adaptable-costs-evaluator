defmodule AdaptableCostsEvaluator.Validators.LabelValidator do
  @behaviour AdaptableCostsEvaluator.Validators.Validator

  @label_regexp ~r/^[a-zA-Z_$][a-zA-Z_$0-9]*$/

  def validate(changeset) do
    Ecto.Changeset.validate_format(changeset, :label, @label_regexp)
  end
end
