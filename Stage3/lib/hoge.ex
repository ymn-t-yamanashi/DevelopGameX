defmodule Hoge do
  import Exray.Core.Window
  import Exray.Core.Drawing
  import Exray.Core.Timing
  alias Exray.Shapes.Basic
  alias Exray.Text.Drawing
  alias Exray.Core.Input.Keyboard

  def run(width \\ 800, height \\ 600, title \\ "DevelopGameX") do
    init_window(width, height, title)
    set_target_fps(30)

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
    update_player(character_data)
    |> update_enems()
  end

  defp update_player(%{player: player} = character_data) do
    x =
      Keyboard.get_key_pressed()
      |> move()
      |> then(&(&1 + player.x))

    character_data
    |> Map.merge(%{player: %{x: x, y: character_data.player.y}})
  end

  defp update_enems(%{enemys: enemys} = character_data)do
    character_data
    |> Map.merge(%{enemys: Enum.map(enemys, &update_enem/1)})
  end

  defp update_enem(%{x: x, y: y}) when y > 650, do: initialization_enemy()
  defp update_enem(%{x: x, y: y}), do: %{x: x, y: y + 5}

  defp draw(character_data) do
    clear_background(Exray.Utils.Colors.white())
    begin_drawing()

    # ここに描画処理
    draw_player(character_data)
    draw_enems(character_data)

    end_drawing()
    character_data
  end

  defp draw_player(%{player: player}) do
    Basic.draw_circle(
      player.x,
      player.y,
      10.0,
      Exray.Utils.Colors.blue()
    )
  end

  defp draw_enems(%{enemys: enemys}), do: Enum.each(enemys, &draw_enem/1)

  defp draw_enem(%{x: x, y: y}) do
    Basic.draw_circle(
      x,
      y,
      10.0,
      Exray.Utils.Colors.red()
    )
  end

  defp initialization_character_data do
    %{
      player: %{x: 400, y: 550},
      enemys: Enum.map(1..100, fn _-> initialization_enemy() end)
    }
  end

  defp initialization_enemy, do: %{x: Enum.random(2..15) * 50, y: Enum.random(-1..-40) * 50}

  defp move(262), do: 50
  defp move(263), do: -50
  defp move(_), do: 0
end
