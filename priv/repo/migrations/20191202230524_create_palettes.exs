defmodule ColorPicker.Repo.Migrations.CreatePalettes do
  use Ecto.Migration

  def up do
    execute """
      create table palettes(
        id serial primary key,
        colors text[],
        inserted_at timestamptz not null default now(),
        updated_at timestamptz not null default now()
      );
    """
  end

  def down do 
    execute """
      drop table palettes;
    """
  end
end
