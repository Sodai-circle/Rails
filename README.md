# Rails環境構築

- Rails6 + Nginx + Puma + Mysql の環境です
- dockerを使ったrailsの環境構築なのでraildockと名付けています。



## RailDock

1. リポジトリをクローン
   
   ```
   git clone https://gitlab.com/welcome-to-sodai/rails.git rails_app/raildock
   ```
   
2. raildock階層で
   ```
   cp env-example .env
   ```
   必要に応じて編集する
   
3. 同じくraildock階層で

   ```
   docker-compose build workspace nginx mysql
   ```

4. コンテナを構築、起動

   ```
   docker-compose up workspace nginx mysql
   ```
   
      初回はかなり時間かかる場合があるのと、終わっても終わったかわかりにくいところが難点です。
   
      必ず電波の環境が良いところで行ってください。永遠に終わりません。
   
      目安としては最悪でも30分で終わると思います。
   
   - `workspace_1  | Installing nokogiri 1.10.10 with native extensions`
   
   - `workspace_1  | Installing sassc 2.4.0 with native extensions`
   
     
   
      この2つがかなり時間かかります。
   
      終わったときは、`Listening on tcp://0.0.0.0:3000`
   
   これが下から2行目くらいに出てると思います。根気よく待ちましょう。


## 環境変数とデータベースの設定

- srcにあるGemfileに追加

  ```Gemfile:Gemfile
  gem 'dotenv-rails'
  ```

- raildock階層で

  ※人によりけりですが、`docker-compose up workspace nginx mysql`これを上で実行した後、すぐにここに来ている場合は、コマンドラインが占拠されているはずですので、新規のコマンドラインウィンドウを立ち上げてからこのコマンドを打ってください。

  ```bash
  docker-compose exec workspace bash
  ```

  コンテナに入ったら

  ```bash
  bundle install
  ```

- src/config/database.ymlを以下で上書き

  ```yml:database.yml
  default: &default
    adapter: mysql2
    encoding: utf8
    pool: <%= ENV.fetch("RAILS_MAX_THREADS") { 5 } %>
    username: <%= ENV.fetch('MYSQL_USER') { 'root' } %>
    password: <%= ENV.fetch('MYSQL_PASSWORD') { 'password' } %>
    host: <%= ENV.fetch('MYSQL_HOST') { 'db' } %>
  
  development:
    <<: *default
    database: default
  
  # test:
  #   <<: *default
  #   database: webapp_test
  ```

- src/.envを追加し記述

  ```txt:.env
  MYSQL_HOST=mysql
  MYSQL_USER=default
  MYSQL_PASSWORD=secret
  ```

- 一度コンテナを再起動

  - コンテナから抜け出す
  - コンテナをストップさせる
  - 以下のコマンドを打つ

  ```
  docker-compose down
  docker-compose up workspace nginx mysql
  ```

  ※少し時間かかるので気長に待つ

- コンテナ内で

  ```
  rails db:create
  rails g scaffold User name:string email:string
  rails db:migrate
  ```

- [ここに](http:/localhost)アクセスし、起動しているか確認

- [ここに](http:/localhost/users)アクセスし、データベースが動いているか確認

  - 適当にユーザーとか作って、作れていればOK
  - dockerを再起動してもユーザーは残っているはずです

## 使い方

### 始めるとき 

raildockの階層で

```
docker-compose up -d workspace nginx mysql
```

※少し時間かかるのですぐにアクセスしてもダメな時がある。(初回起動よりは全然早いです。ただこのrails立ち上げ遅い問題なんとか解決したいです。アプリケーションサーバを介するから仕方ないのかな。)



### 終わるとき

```
docker-compose down
```



## まとめ

- Railsの環境構築ができた



### Next Step

- Railsを勉強していくのみ!

- [Railsチュートリアル](https://railstutorial.jp/chapters/beginning?version=5.1)

- Sodai.でチュートリアル作ってくれる方募集中です...

   

