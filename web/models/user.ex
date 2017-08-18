defmodule Chatter.User do
  use Chatter.Web, :model
  use Coherence.Schema
  alias Chatter.User
  alias Chatter.Repo

  schema "users" do
    field :name, :string
    field :last_name, :string
    field :email, :string
    field :token, :string, virtual: true
    coherence_schema

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:name, :last_name, :email] ++ coherence_fields)
    |> validate_required([:name, :last_name, :email])
    |> validate_coherence(params)
  end

  def find_by(column, value) do
    User
    |> where([u], field(u, ^column) == ^value)
    |> first
    |> Repo.one
  end
end
