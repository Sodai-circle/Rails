# Rails環境構築

- Rails6 + Nginx + Puma + Mysql の環境です
- dockerを使ったrailsの環境構築なのでraildockと名付けています。



## RailDock

1. リポジトリをクローン
   
   ```
   git clone https://gitlab.com/welcome-to-sodai/rails.git rails_app/raildock
   ```
   
2. .envをコピー
   ```
   cp env-example .env
   ```
   必要に応じて編集する
   
3. raildock階層で

   ```
   docker-compose build workspace nginx mysql
   ```

4. コンテナを構築、起動

   ```
   docker-compose up workspace nginx mysql
   ```


## 環境変数とデータベースの設定

- Gemfileに

  ```Gemfile:Gemfile
  gem 'dotenv-rails'
  ```

- raildock階層で

  ```bash
  docker-compose exec workspace bash
  ```

  コンテナに入ったら

  ```bash
  bundle install
  ```

- database.ymlに記述

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

- src配下(Gemfileなどと同じ階層)に.envを追加し記述

  ```txt:.env
  MYSQL_HOST=mysql
  MYSQL_USER=default
  MYSQL_PASSWORD=secret
  ```

- 一度コンテナを再起動

  ```
  docker-compose down
  docker-compose up workspace nginx mysql
  ```

- コンテナ内で

  ```
  rails db:create
  rails g scaffold User name:string email:string
  rails db:migrate
  ```

- [ここに](http:/localhost)アクセスし、起動しているか確認

- [ここに](http:/localhost/users)アクセスし、データベースが動いているか確認



## 使い方

- 始めるとき raildockの階層で

  ```
  docker-compose up -d workspace nginx mysql
  ```

  たまに時間かかるのですぐにアクセスしてもダメな時がある。

- 終わるとき

  ```
  docker-compose down
  ```




### まとめ

- Railsの環境構築ができた



### Next Step

- Railsを勉強していくのみ!

- [Railsチュートリアル](https://railstutorial.jp/chapters/beginning?version=5.1)

- Sodai.でチュートリアル作ってくれる方募集中です...

   

