defmodule Hoge do
  # Exrayの機能をインポート（ウィンドウ、描画、タイマー関連）
  import Exray.Core.Window
  import Exray.Core.Drawing
  import Exray.Core.Timing
  # 矩形などの基本形状を扱うモジュール
  alias Exray.Shapes.Basic
  # 文字列描画機能
  alias Exray.Text.Drawing
  # キーボード入力管理
  alias Exray.Core.Input.Keyboard
  # 色管理
  alias Exray.Utils.Colors

  # 定数定義
  @window_width 800
  @window_height 600
  @player_initial_x 400
  @player_initial_y 550
  @bottom_y 650
  @enemy_count 10
  @player_movement_speed 30
  @enem_movement_speed 2
  @rectangle_size 25.0
  @text_position_x 10
  @text_position_y 10
  @text_size 30
  @fps 60
  @right_arrow_key 262
  @left_arrow_key 263

  def run(width \\ @window_width, height \\ @window_height, title \\ "DevelopGameX") do
    # ウィンドウ初期化
    init_window(width, height, title)
    # FPSを30に設定
    set_target_fps(@fps)

    # 初期キャラクターデータを作成し、メインループを開始
    initialization_character_data()
    |> main_loop()

    if window_should_close?(), do: close_window()
    :ok
  end

  defp main_loop(character_data) do
    # ウィンドウが準備されていない場合はループを継続
    unless window_is_ready?(), do: main_loop(character_data)

    # ウィンドウが閉じられていない限り描画と更新を繰り返す
    unless window_should_close?() do
      draw(character_data)
      |> update()
      |> main_loop()
    end
  end

  # ゲームオブジェクトの更新処理
  defp update(character_data) do
    character_data
    # プレイヤーの移動を更新
    |> update_player()
    # 敵キャラクターの移動を更新
    |> update_enems()
    # 衝突カウントを更新
    |> update_count()
    # 弾丸の移動を更新
    |> update_bullets()
  end

  # 初期キャラクターデータを生成する関数
  defp initialization_character_data do
    %{
      # プレイヤー初期位置（中央下）
      player: %{x: @player_initial_x, y: @player_initial_y},
      # 敵キャラクターを@enemy_count体生成
      enemys: Enum.map(1..@enemy_count, fn _ -> initialization_enemy(true) end),
      # 初期カウント数
      count: 0,
      bullets: Enum.map(1..10, fn _ -> %{x: 300.0, y: 0.0, existence: true} end)
    }
  end

  # 矩形を作成する関数（共通化）
  defp create_rectangle(x, y) do
    %Exray.Structs.Rectangle{
      height: @rectangle_size,
      width: @rectangle_size,
      x: x * 1.0,
      y: y * 1.0
    }
  end

  # 敵キャラクターの初期位置を生成する関数
  defp initialization_enemy(existence),
    do: %{x: Enum.random(50..750), y: Enum.random(-100..-4000), existence: existence}

  # 移動量を取得する関数（左右移動）
  # 右矢印キー
  defp move(@right_arrow_key), do: @player_movement_speed
  # 左矢印キー
  defp move(@left_arrow_key), do: -@player_movement_speed
  # その他の場合は移動なし
  defp move(_), do: 0

  # 衝突判定を行う関数（矩形同士）
  defp collided?(%{x: x1, y: y1}, %{x: x2, y: y2}),
    do:
      collided?(
        x1,
        y1,
        @rectangle_size,
        @rectangle_size,
        x2,
        y2,
        @rectangle_size,
        @rectangle_size
      )

  # 衝突判定を行う関数（矩形同士）
  defp collided?(x1, y1, w1, h1, x2, y2, w2, h2) do
    # 矩形の衝突判定
    x1 <= x2 + w2 &&
      x1 + w1 >= x2 &&
      y1 <= y2 + h2 &&
      y1 + h1 >= y2
  end

  # 描画処理を行う関数
  defp draw(character_data) do
    begin_drawing()
    # 背景をクリア（黒）
    clear_background(Colors.black())
    # プレイヤー、敵キャラクター、カウントの描画を実行
    draw_player(character_data)
    draw_enems(character_data)
    draw_count(character_data)

    draw_bullets(character_data)

    end_drawing()
    character_data
  end

  # カウントを描画する関数
  defp draw_count(%{count: count}) do
    # 緑色で文字列描画
    Drawing.draw_text(
      "count: #{count}",
      @text_position_x,
      @text_position_y,
      @text_size,
      Colors.green()
    )
  end

  # 敵キャラクターを描画する関数
  defp draw_enems(%{enemys: enemys}), do: Enum.each(enemys, &draw_enem/1)

  # 個々の敵キャラクターを描画する関数
  defp draw_enem(%{x: x, y: y, existence: true}) do
    # 矩形を作成
    create_rectangle(x, y)
    # 赤色で描画
    |> Basic.draw_rectangle_rec(Colors.red())
  end

  defp draw_enem(%{x: _x, y: _y, existence: false}), do: nil

  # 弾丸を描画する関数
  defp draw_bullets(%{bullets: bullets}), do: Enum.each(bullets, &draw_bullet/1)

  # 個々の弾丸を描画する関数
  defp draw_bullet(%{x: x, y: y, existence: true}) do
    # 矩形を作成
    create_rectangle(x, y)
    # 赤色で描画
    |> Basic.draw_rectangle_rec(Colors.lightgray())
  end

  defp draw_bullet(%{x: _x, y: _y, existence: false}), do: nil


  # プレイヤーを描画する関数
  defp draw_player(%{player: player}) do
    # 矩形を作成
    create_rectangle(player.x, player.y)
    # 青色で描画
    |> Basic.draw_rectangle_rec(Colors.blue())
  end

  # 敵キャラクターの移動を更新する関数
  defp update_enems(%{enemys: enemys} = character_data) do
    character_data
    |> Map.merge(%{enemys: Enum.map(enemys, &update_enem/1)})
  end

  # 個々の敵キャラクターを更新する関数（落下）
  # 床に達したらリセット
  defp update_enem(%{x: x, y: y, existence: existence }) when y > @bottom_y, do: initialization_enemy(existence)
  # 敵を下方向に移動
  defp update_enem(%{x: x, y: y, existence: existence}), do: %{x: x, y: y + @enem_movement_speed, existence: existence}


  # 弾丸の移動を更新する関数
  defp update_bullets(%{bullets: bullets} = character_data) do
    character_data
    |> Map.merge(%{bullets: Enum.map(bullets, &update_bullet/1)})
  end

  # 個々の弾丸を更新する関数
  defp update_bullet(%{x: x, y: y, existence: existence }) when y < 0, do: %{x: x, y: @bottom_y, existence: existence}
  # 弾丸を上方向に移動
  defp update_bullet(%{x: x, y: y, existence: existence}), do: %{x: x, y: y - @enem_movement_speed, existence: existence}

  # 衝突カウントを更新する関数
  defp update_count(%{player: player, enemys: enemys, count: count} = character_data) do
    # 各敵キャラクターとの衝突判定を行い、結果を集計
    collided_and_enemy =
      Enum.map(enemys, fn enemy -> update_collided_and_enemy(player, enemy) end)

    # 新しいカウント数を計算し、更新後の敵キャラクター配列を作成
    new_count = Enum.map(collided_and_enemy, fn i -> i.collided end) |> Enum.sum()
    new_enemys = Enum.map(collided_and_enemy, fn i -> i.enemy end)

    # 更新後のデータをマージして返す
    character_data
    |> Map.merge(%{count: count + new_count, enemys: new_enemys})
  end

  # 個々の敵キャラクターとの衝突判定を行う関数
  defp update_collided_and_enemy(player, enemy) do
    collided = collided?(player, enemy)

    %{
      # 衝突フラグ（1/0）
      collided: if(collided, do: 1, else: 0),
      # 衝突時敵をリセット
      enemy: if(collided, do: initialization_enemy(false), else: enemy)
    }
  end

  # プレイヤーの移動を更新する関数
  defp update_player(%{player: player} = character_data) do
    # キーボード入力からプレイヤーのx座標を更新
    x =
      Keyboard.get_key_pressed()
      # 移動量を取得（左右移動）
      |> move()
      |> then(&(&1 + player.x))

    # 更新後のプレイヤー位置をマージして返す
    character_data
    |> Map.merge(%{player: %{x: x, y: player.y}})
  end
end
