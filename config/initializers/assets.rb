# Be sure to restart your server when you modify this file.

# Version of your assets, change this if you want to expire all your assets.
Rails.application.config.assets.version = '1.0'

# Add additional assets to the asset load path.
# Rails.application.config.assets.paths << Emoji.images_path
# Add Yarn node_modules folder to the asset load path.
Rails.application.config.assets.paths << Rails.root.join('node_modules')
# Precompile additional assets.
# application.js, application.css, and all non-JS/CSS in the app/assets
# folder are already added.
Rails.application.config.assets.precompile += %w( admin.js admin.css vendor/assets/stylesheets/* )
Rails.application.config.assets.precompile += %w[color.css users/*.sass users/*.css buyer/order_list.sass stylesheets/* newji.css]

Rails.application.config.assets.precompile += %w[application_admin.scss application_admin.js devise.scss]

Rails.application.config.assets.precompile += %w[home.scss home.js calendar.scss menu.js]
Rails.application.config.assets.precompile += %w[components/* buyer/* templates/*.css dropzone.js my_dropzone.js]
Rails.application.config.assets.precompile += %w[dropzone/*.js]

# Integrate vender new front end
Rails.application.config.assets.precompile += %w[css/* js/* plugins/* img/*]
