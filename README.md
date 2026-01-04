# Easel - image viewer

![alt text](https://github.com/asip/easel-back/blob/main/public/palette.svg)

This is backend of [Easel](https://github.com/asip/easel).

Rails8.1 + Devise(authentication) + Pagy(paging) +
Shrine(upload) + No Fly List(tag) +
RailsAdmin (management console) + Discard(soft delete) +
Hotwire (Turbo + Stimulus3) + Tailwind CSS v4 + daisyUI v5

The legacy frontend + backend implemented by Ruby on Rails moved to [easel-legacy](https://github.com/asip/easel-legacy).
(+ Vue.js 3)

This README would normally document whatever steps are necessary to get the
application up and running.

Things you may want to cover:

* Ruby version : 4.0
* Rails version : 8.1
* System dependencies : pnpm & postgresql & minio & imgproxy & valkey & libvips & direnv
* Deployment instructions
  * Run `bundle install --path vendor/bundle` to install the required Rubygems
  * Run `pnpm install` to install the required NPM packages
  * Run `cp .env.local.example .env` to edit environment variables
  * Run `EDITOR="vi" bin/rails credentials:edit` to create credentials
  * Run `direnv allow` to set environment variables
  * Run `bundle exec rails db:create` to create a development database
  * Run `bundle exec rails db:migrate` to create database schema
  * Run `bundle exec rails db:seed` to sample records
  * Run `bin/dev` to spin up the Rails dev server
  * Hit [localhost:3000](http://localhost:3000/) and you should be ready to go!

* ...

## License

The MIT License (MIT). Please see [License File](https://github.com/asip/easel/blob/main/LICENSE-MIT.txt) for more information.
