defmodule Kakebosan.Accounting.Side do
  @type t :: %__MODULE__{
          id: Integer.t(),
          name: String.t()
        }

  defstruct id: nil,
            name: nil

  @debit %{id: 1, name: "借方"}
  def debit, do: @debit
  @credit %{id: 2, name: "貸方"}
  def credit, do: @credit
end
