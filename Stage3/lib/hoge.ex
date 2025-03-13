defmodule Hoge do
  import Exray.Core.Window
  import Exray.Core.Drawing
  import Exray.Core.Timing
  alias Exray.Shapes.Basic
  alias Exray.Text.Drawing
  alias Exray.Core.Input.Keyboard
  alias Exray.Utils.Colors

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
    |> update_count()
  end

  defp update_player(%{player: player} = character_data) do
    x =
      Keyboard.get_key_pressed()
      |> move()
      |> then(&(&1 + player.x))

    character_data
    |> Map.merge(%{player: %{x: x, y: player.y}})
  end

  defp update_count(%{player: player, enemys: enemys, count: count} = character_data) do
    collided_and_enemy =
      Enum.map(enemys, fn enemy -> update_collided_and_enemy(player, enemy) end)

    new_count = Enum.map(collided_and_enemy, fn i -> i.collided end) |> Enum.sum()
    new_enemys = Enum.map(collided_and_enemy, fn i -> i.enemy end)

    character_data
    |> Map.merge(%{count: count + new_count, enemys: new_enemys})
  end

  defp update_collided_and_enemy(player, enemy) do
    collided = collided?(player, enemy)

    %{
      collided: if(collided, do: 1, else: 0),
      enemy: if(collided, do: initialization_enemy(), else: enemy)
    }
  end

  defp update_enems(%{enemys: enemys} = character_data) do
    character_data
    |> Map.merge(%{enemys: Enum.map(enemys, &update_enem/1)})
  end

  defp update_enem(%{x: x, y: y}) when y > 650, do: initialization_enemy()
  defp update_enem(%{x: x, y: y}), do: %{x: x, y: y + 3}

  defp draw(character_data) do
    clear_background(Colors.black())
    begin_drawing()

    # ここに描画処理
    draw_player(character_data)
    draw_enems(character_data)
    draw_count(character_data)

    end_drawing()
    character_data
  end

  defp draw_player(%{player: player}) do
    create_rectangle(player.x, player.y)
    |> Basic.draw_rectangle_rec(Colors.blue())
  end

  defp draw_count(%{count: count}) do
    Drawing.draw_text("count: #{count}", 10, 10, 30, Colors.green())
  end

  defp draw_enems(%{enemys: enemys}), do: Enum.each(enemys, &draw_enem/1)

  defp draw_enem(%{x: x, y: y}) do
    create_rectangle(x, y)
    |> Basic.draw_rectangle_rec(Colors.red())
  end

  defp initialization_character_data do
    %{
      player: %{x: 400, y: 550},
      enemys: Enum.map(1..50, fn _ -> initialization_enemy() end),
      count: 0
    }
  end

  defp create_rectangle(x, y) do
    %Exray.Structs.Rectangle{
      height: 25.0,
      width: 25.0,
      x: x * 1.0,
      y: y * 1.0
    }
  end

  defp initialization_enemy, do: %{x: Enum.random(2..40) * 20, y: Enum.random(-1..-40) * 20}

  defp move(262), do: 30
  defp move(263), do: -30
  defp move(_), do: 0

  defp collided?(%{x: x1, y: y1}, %{x: x2, y: y2}), do: collided?(x1, y1, 25, 25, x2, y2, 25, 25)

  def collided?(x1, y1, w1, h1, x2, y2, w2, h2) do
    x1 <= x2 + w2 && x1 + w1 >= x2 && y1 <= y2 + h2 && y1 + h1 >= y2
  end
end
