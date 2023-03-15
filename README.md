# Easel - image viewer

![Typing SVG](https://github.com/asip/easel-back/blob/main/public/palette.svg)

This is backend of Easel.

Rails7.0 + Sorcery(authentication) + Kamnari(paging) +  
Shrine(upload) + ActsAsTaggableOn(tag) + Vue.js 3 +  
Hotwire (Turbo + Stimulus3) +Bootstrap5 +  
Web API (for easel-front) +  
RailsAdmin (management console)

This README would normally document whatever steps are necessary to get the
application up and running.

Things you may want to cover:

* Ruby version : 3.2.1
* Rails version : 7.0.4
* System dependencies : yarn (v1.22.19) & mysql
* Deployment instructions
  - Run `bundle install --path vendor/bundle` to install the required Rubygems
  - Run `yarn install` to install the required NPM packages
  - Run `bundle exec rails db:create` to create a development database
  - Run `bundle exec rails db:migrate` to create database schema
  - Run `bundle exec rails db:seed` to sample records
  - Run `bin/rails assets:precompile` to bundle the included javascript modules 
  - Run `bin/dev` to spin up the Rails dev server
  - Hit [localhost:3000](http://localhost:3000/) and you should be ready to go!

* ...

## License

The MIT License (MIT). Please see [License File](https://github.com/asip/easel/blob/main/LICENSE-MIT.txt) for more information.
