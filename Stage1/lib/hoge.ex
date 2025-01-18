defmodule Hoge do

  # We import Exray.Core.Window, like we did in IEX.
  import Exray.Core.Window
  # But, we also import Exray.Core.Drawing, to have access to begin_draw() and end_draw() calls.
  # This is to poll for window_should_close?() events, as without end_draw() no inputs will be polled at all.
  import Exray.Core.Drawing
  # We also need to import Exray.Core.Timing in order to set our FPS. This is VERY important.
  import Exray.Core.Timing
  alias Exray.Shapes.Basic
  alias Exray.Text.Drawing
  alias Exray.Core.Input.Keyboard

  def run(width \\ 640, height \\ 420, title \\ "Hello World!") do
    init_window(width, height, title)
    set_target_fps(60) # <-- SUPER important! Call this just after you init_window, or segfaults are gonna happen a lot.
    main_loop(25)

    # As another layer of safety, if for some reason our window *didn't* close, we can do it here in this check.
    if window_should_close?() do
      close_window()
    end

    :ok # :ok, because we're :ok :)
  end

  defp main_loop(x) do

    # Stay out of update and draw unless our window is ready to update and draw.
    unless window_is_ready?(), do: main_loop(x)

    # If at any point we press Raylib's default "Quit Application" key, (ESCAPE), stop looping and exit.
    unless window_should_close?() do
      update()
      draw(x)
      key_code = Keyboard.get_key_pressed()

      z = move(key_code)

      x = if x > 665, do: 25, else: x + z
      main_loop(x)
    end
  end

  defp move(48), do: 10
  defp move(49), do: -10
  defp move(_), do: 0

  defp update() do
    # Nothing yet!
  end

  defp draw(x) do
    # Before drawing, we'll clear the background with the Exray.Utils.Colors.black function result- Which is %Exray.Structs.Color{r: 0, g: 0, b: 0, a: 255}.
    clear_background(Exray.Utils.Colors.white())
    begin_drawing()
    text = DateTime.utc_now()
    |> DateTime.to_string()

    Drawing.draw_text(text, 10, 10, 20, Exray.Utils.Colors.blue())
    # Nothing yet!
    Basic.draw_circle(x, 100, 25.0, Exray.Utils.Colors.blue())


    #|> Integer.to_string()
    # Drawing.draw_text(key_code, 20, 200, 20, Exray.Utils.Colors.blue())

    end_drawing()
  end

end
