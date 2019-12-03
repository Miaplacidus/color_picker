defmodule ColorPicker.Features.PalettePlaygroundTest do 
  use ExUnit.Case
  use Hound.Helpers
  alias ColorPickerWeb.Router.Helpers, as: Routes
  @endpoint ColorPickerWeb.Endpoint

  hound_session()

  describe "picking colors" do
    setup do
      :ok = Ecto.Adapters.SQL.Sandbox.checkout(ColorPicker.Repo)
      Ecto.Adapters.SQL.Sandbox.mode(ColorPicker.Repo, {:shared, self()})
    end
    
    test "user sees color bar corresponding to rgb input" do 
      Routes.page_url(@endpoint, :index)
      |> navigate_to()

      element = find_element(:name, "color-picker")
      fill_field(element, "150,11,50")

      send_keys(:enter)

      assert(
        find_element(:css, "div.color-picker-bar")
        |> css_property("background-color") == "rgb(150, 11, 50)"
      )
    end
    
    test "user cannot enter non-rgb format values" do 
      Routes.page_url(@endpoint, :index)
      |> navigate_to()

      element = find_element(:name, "color-picker")
      fill_field(element, "abc,11,50")

      send_keys(:enter)

      assert(
        find_element(:css, "div.color-picker-error")
        |> inner_text() == "enter value in this format: 123,456,789"
      )
    end
  end

  describe "generating palettes" do 
    test "user sees color bar corresponding to rgb input" do 
      Routes.page_url(@endpoint, :index)
      |> navigate_to()

      element = find_element(:name, "rgb1")
      fill_field(element, "150,11,50")

      send_keys(:enter)

      assert(
        find_element(:css, ".palette-inputs .color-bar")
        |> css_property("background-color") == "rgb(150, 11, 50)"
      )
    end

    @tag :pending
    test "user sees newly-generated palette in list" do 
    end

    @tag :pending
    test "user cannot enter non-rgb format values" do 
    end
  end

  describe "deleting palettes" do
    @tag :pending
    test "palette disappears from list following deletion" do 
    end
  end

  describe "editing palettes" do
    @tag :pending
    test "user sees color bar corresponding to rgb input" do 
    end

    @tag :pending
    test "user cannot enter non-rgb format values" do 
    end
  end
end