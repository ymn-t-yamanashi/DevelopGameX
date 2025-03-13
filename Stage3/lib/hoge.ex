defmodule Hoge do
  import Exray.Core.Window
  import Exray.Core.Drawing
  import Exray.Core.Timing
  alias Exray.Shapes.Basic
  alias Exray.Text.Drawing
  alias Exray.Core.Input.Keyboard

  def run(width \\ 800, height \\ 600, title \\ "DevelopGameX") do
    init_window(width, height, title)
    set_target_fps(60)

    initialization_character_data()
    |> main_loop()

    if window_should_close?(), do: close_window()
    :ok
  end

  defp main_loop(character_data) do
    unless window_is_ready?(), do: main_loop(character_data)

    unless window_should_close?() do
      draw(character_data)
      |> update()
      |> main_loop()
    end
  end

  # ここに座標計算
  defp update(character_data) do
    character_data
  end

  defp draw(character_data) do
    clear_background(Exray.Utils.Colors.white())
    begin_drawing()

    # ここに描画処理
    Basic.draw_circle(
      character_data.player.x,
      character_data.player.x,
      10.0,
      Exray.Utils.Colors.blue()
    )

    end_drawing()
    character_data
  end

  defp initialization_character_data do
    %{
      player: %{x: 300, y: 300},
      enemy: [
        %{x: 100, y: 200},
        %{x: 200, y: 100}
      ]
    }
  end
end
