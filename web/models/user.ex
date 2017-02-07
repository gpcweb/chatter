defmodule Chatter.User do
  use Chatter.Web, :model

  schema "users" do
    field :name, :string
    field :last_name, :string
    field :email, :string

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:name, :last_name, :email])
    |> validate_required([:name, :last_name, :email])
  end
end
