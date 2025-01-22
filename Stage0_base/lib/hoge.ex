defmodule Hoge do
  import Exray.Core.Window
  import Exray.Core.Drawing
  import Exray.Core.Timing
  alias Exray.Shapes.Basic
  alias Exray.Text.Drawing
  alias Exray.Core.Input.Keyboard

  def run(width \\ 800, height \\ 600, title \\ "Hello World!") do
    init_window(width, height, title)
    set_target_fps(60)
    main_loop(25)

    if window_should_close?() do
      close_window()
    end

    :ok
  end

  defp main_loop(x) do
    unless window_is_ready?(), do: main_loop(x)

    unless window_should_close?() do
      draw(x)
      |> update()
      |> main_loop()
    end
  end

  # ここに座標計算
  defp update(x), do: x

  defp draw(x) do
    clear_background(Exray.Utils.Colors.white())
    begin_drawing()

    # ここに描画処理
    Basic.draw_circle(400, 300, 10.0, Exray.Utils.Colors.blue())

    end_drawing()
    x
  end
end
