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
      x = if x > 360, do: 1, else: x + 1
      main_loop(x)
    end
  end

  defp draw(x) do
    clear_background(Exray.Utils.Colors.white())
    begin_drawing()

    [px, py] = point(x * 4, 400, 300, x)
    Basic.draw_circle(px, py, 10.0, Exray.Utils.Colors.blue())

    end_drawing()
  end

  def point(angle, x, y, radius) do
    c = :math.pi() / 180
    px = :math.cos(c * angle) * radius + x
    py = :math.sin(c * angle) * radius + y
    [trunc(px), trunc(py)]
  end
end
