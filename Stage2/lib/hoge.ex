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

  defp update(x) when x > 100, do: 0
  defp update(x), do: x + 1

  defp draw(x) do
    clear_background(Exray.Utils.Colors.white())
    begin_drawing()

    Enum.each(10..72, fn r -> draw_circle_point(r, x) end)

    end_drawing()
    x
  end

  defp draw_circle_point(r, x) do
    [px, py] = point(r * 20, 400, 300, x * r * 0.1)
    Basic.draw_circle(px, py, 10.0, Exray.Utils.Colors.blue())
  end

  def point(angle, x, y, radius) do
    c = :math.pi() / 180
    px = :math.cos(c * angle) * radius + x
    py = :math.sin(c * angle) * radius + y
    [trunc(px), trunc(py)]
  end
end
