defmodule ColorPicker.Palette do
  import Ecto.Query, warn: false
  use Ecto.Schema
  import Ecto.Changeset

  alias ColorPicker.Palette
  alias ColorPicker.Repo

  schema "palettes" do
    field :colors, {:array, :string}
    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(%Palette{} = palette, attrs \\ %{}) do
    palette
    |> cast(attrs, [:colors])
    |> validate_required([:colors])
  end

  def get_palette(palette_id) do 
    Repo.get(Palette, palette_id)
  end

  def get_palettes() do 
    query = from p in Palette, order_by: [asc: p.inserted_at]
    Repo.all(query)
  end

  def create_palette(attrs \\ %{}) do
    %Palette{}
    |> Palette.changeset(attrs)
    |> Repo.insert()
  end

  def update_palette(%Palette{} = palette, attrs) do
    palette
    |> Palette.changeset(attrs)
    |> Repo.update()
  end

  def delete_palette(%Palette{} = palette) do
    Repo.delete(palette)
  end
end
