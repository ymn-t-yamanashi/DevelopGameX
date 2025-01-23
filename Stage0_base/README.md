# DevelopGameX スターターキット

## Stage0_baseをコピーして下さい
```sh
$ cp Stage0_base Stage100
```
※Stage100の部分は自由につけて下さい

## ライブラリ取得＆コンパイル
下記は1度だけ必要です
```sh
$ mix deps.get
$ mix compile.exray
```

## 実行できるか確認して下さい
```sh
$ sh run.sh
```


## lib/hoge.exを編集して下さい
- draw関数の`# ここに描画処理`を書き換えて下さい
- https://hexdocs.pm/exray/Exray.Shapes.Basic.html を参考にして下さい

## 参考資料
Exrayを使ってElixirで円を描画してみる

https://qiita.com/t-yamanashi/items/35f89051c53899e49d70
