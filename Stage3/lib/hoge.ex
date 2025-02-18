# Hogeモジュールを定義します。
defmodule Hoge do
  # ExrayライブラリのWindow、Drawing、Timingモジュールをインポートします。
  import Exray.Core.Window
  import Exray.Core.Drawing
  import Exray.Core.Timing

  # ExrayライブラリのShapes.BasicとText.Drawingモジュールをエイリアスとしてインポートします。
  alias Exray.Shapes.Basic
  alias Exray.Text.Drawing

  # ExrayライブラリのInput.Keyboardモジュールをエイリアスとしてインポートします。
  alias Exray.Core.Input.Keyboard

  # ゲームの初期化関数です。ウィンドウサイズ、タイトルを指定できます。デフォルト値は幅800px、高さ600px、タイトル"DevelopGameX"です。
  def run(width \\ 800, height \\ 600, title \\ "DevelopGameX") do
    # 指定されたサイズとタイトルでウィンドウを初期化します。
    init_window(width, height, title)
    # フレームレートを60FPSに設定します。
    set_target_fps(60)

    # メインループを開始します。引数は初期値として25を渡しています。
    main_loop(25)

    # ウィンドウが閉じられるべきかどうかを確認し、閉じられる場合はウィンドウを閉じます。
    if window_should_close?() do
      close_window()
    end

    # 成功を表す:okを返します。
    :ok
  end

  # メインループ関数です。引数はループの内部で更新される値を受け取ります。
  defp main_loop(x) do
    # ウィンドウが準備完了になるまで、自身を再帰呼び出しして待機します。
    unless window_is_ready?(), do: main_loop(x)

    # ウィンドウが閉じられるべきでない場合、以下の処理を行います。
    unless window_should_close?() do
      # draw関数で描画処理を行い、update関数で更新処理を行い、再びmain_loop関数に再帰呼び出しします。
      draw(x)
      |> update()
      |> main_loop()
    end
  end

  # 更新処理を行う関数です。引数を受け取り、そのまま返却します。(現状では何もしない)
  defp update(x), do: x

  # 描画処理を行う関数です。引数を受け取り、描画処理を行い、そのまま返却します。
  defp draw(x) do
    # 背景を白でクリアします。
    clear_background(Exray.Utils.Colors.white())

    # 描画開始
    begin_drawing()

    # 円を描画します。中心座標は(400, 300)、半径は10.0、色は青です。
    Basic.draw_circle(400, 300, 10.0, Exay.Utils.Colors.blue)

    # 描画終了
    end_drawing()

    # 引数をそのまま返却します。
    x
  end
end
