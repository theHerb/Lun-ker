diff --git a/Gemfile b/Gemfile
old mode 100644
new mode 100755
index 724cc1a..d6d7a9d
--- a/Gemfile
+++ b/Gemfile
@@ -37,6 +37,9 @@ end
 
 gem 'jquery-rails'
 
+gem "mini_magick"
+gem "carrierwave"
+
 # To use ActiveModel has_secure_password
 # gem 'bcrypt-ruby', '~> 3.0.0'
 
diff --git a/Gemfile.lock b/Gemfile.lock
index 5ea6bb5..ee22df8 100644
--- a/Gemfile.lock
+++ b/Gemfile.lock
@@ -35,6 +35,9 @@ GEM
     bourne (1.1.2)
       mocha (= 0.10.5)
     builder (3.0.4)
+    carrierwave (0.8.0)
+      activemodel (>= 3.2.0)
+      activesupport (>= 3.2.0)
     coffee-rails (3.2.2)
       coffee-script (>= 2.2.0)
       railties (~> 3.2.0)
@@ -79,6 +82,8 @@ GEM
       treetop (~> 1.4.8)
     metaclass (0.0.1)
     mime-types (1.19)
+    mini_magick (3.4)
+      subexec (~> 0.2.1)
     mocha (0.10.5)
       metaclass (~> 0.0.1)
     multi_json (1.5.0)
@@ -138,6 +143,7 @@ GEM
     sqlite3 (1.3.7)
     sqlite3 (1.3.7-x86-mingw32)
     state_machine (1.1.2)
+    subexec (0.2.2)
     thor (0.16.0)
     tilt (1.3.3)
     treetop (1.4.12)
@@ -155,11 +161,13 @@ PLATFORMS
   x86-mingw32
 
 DEPENDENCIES
+  carrierwave
   coffee-rails (~> 3.2.1)
   devise
   factory_girl_rails
   heroku
   jquery-rails
+  mini_magick
   pg
   rails (= 3.2.11)
   sass-rails (~> 3.2.3)
diff --git a/app/assets/javascripts/albums.js.coffee b/app/assets/javascripts/albums.js.coffee
new file mode 100644
index 0000000..7615679
--- /dev/null
+++ b/app/assets/javascripts/albums.js.coffee
@@ -0,0 +1,3 @@
+# Place all the behaviors and hooks related to the matching controller here.
+# All this logic will automatically be available in application.js.
+# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/
diff --git a/app/assets/javascripts/photos.js.coffee b/app/assets/javascripts/photos.js.coffee
new file mode 100644
index 0000000..7615679
--- /dev/null
+++ b/app/assets/javascripts/photos.js.coffee
@@ -0,0 +1,3 @@
+# Place all the behaviors and hooks related to the matching controller here.
+# All this logic will automatically be available in application.js.
+# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/
diff --git a/app/assets/stylesheets/albums.css.scss b/app/assets/stylesheets/albums.css.scss
new file mode 100644
index 0000000..f88f6f2
--- /dev/null
+++ b/app/assets/stylesheets/albums.css.scss
@@ -0,0 +1,3 @@
+// Place all the styles related to the albums controller here.
+// They will automatically be included in application.css.
+// You can use Sass (SCSS) here: http://sass-lang.com/
diff --git a/app/assets/stylesheets/photos.css.scss b/app/assets/stylesheets/photos.css.scss
new file mode 100644
index 0000000..1a3e082
--- /dev/null
+++ b/app/assets/stylesheets/photos.css.scss
@@ -0,0 +1,3 @@
+// Place all the styles related to the photos controller here.
+// They will automatically be included in application.css.
+// You can use Sass (SCSS) here: http://sass-lang.com/
diff --git a/app/assets/stylesheets/scaffolds.css.scss b/app/assets/stylesheets/scaffolds.css.scss
index e69de29..6ec6a8f 100644
--- a/app/assets/stylesheets/scaffolds.css.scss
+++ b/app/assets/stylesheets/scaffolds.css.scss
@@ -0,0 +1,69 @@
+body {
+  background-color: #fff;
+  color: #333;
+  font-family: verdana, arial, helvetica, sans-serif;
+  font-size: 13px;
+  line-height: 18px;
+}
+
+p, ol, ul, td {
+  font-family: verdana, arial, helvetica, sans-serif;
+  font-size: 13px;
+  line-height: 18px;
+}
+
+pre {
+  background-color: #eee;
+  padding: 10px;
+  font-size: 11px;
+}
+
+a {
+  color: #000;
+  &:visited {
+    color: #666;
+  }
+  &:hover {
+    color: #fff;
+    background-color: #000;
+  }
+}
+
+div {
+  &.field, &.actions {
+    margin-bottom: 10px;
+  }
+}
+
+#notice {
+  color: green;
+}
+
+.field_with_errors {
+  padding: 2px;
+  background-color: red;
+  display: table;
+}
+
+#error_explanation {
+  width: 450px;
+  border: 2px solid red;
+  padding: 7px;
+  padding-bottom: 0;
+  margin-bottom: 20px;
+  background-color: #f0f0f0;
+  h2 {
+    text-align: left;
+    font-weight: bold;
+    padding: 5px 5px 5px 15px;
+    font-size: 12px;
+    margin: -7px;
+    margin-bottom: 0px;
+    background-color: #c00;
+    color: #fff;
+  }
+  ul li {
+    font-size: 12px;
+    list-style: square;
+  }
+}
diff --git a/app/controllers/albums_controller.rb b/app/controllers/albums_controller.rb
new file mode 100755
index 0000000..e151018
--- /dev/null
+++ b/app/controllers/albums_controller.rb
@@ -0,0 +1,44 @@
+class AlbumsController < ApplicationController
+  def index
+    @albums = Album.all
+  end
+
+  def show
+    @album = Album.find(params[:id])
+  end
+
+  def new
+    @album = Album.new
+  end
+
+  def create
+    @album = Album.new(params[:album])
+    if @album.save
+      flash[:notice] = "Successfully created album."
+      redirect_to @album
+    else
+      render :action => 'new'
+    end
+  end
+
+  def edit
+    @album = Album.find(params[:id])
+  end
+
+  def update
+    @album = Album.find(params[:id])
+    if @album.update_attributes(params[:album])
+      flash[:notice] = "Successfully updated album."
+      redirect_to album_url
+    else
+      render :action => 'edit'
+    end
+  end
+
+  def destroy
+    @album = Album.find(params[:id])
+    @album.destroy
+    flash[:notice] = "Successfully destroyed album."
+    redirect_to albums_url
+  end
+end
diff --git a/app/controllers/photos_controller.rb b/app/controllers/photos_controller.rb
new file mode 100755
index 0000000..15bdfc7
--- /dev/null
+++ b/app/controllers/photos_controller.rb
@@ -0,0 +1,36 @@
+class PhotosController < ApplicationController
+  def new
+    @photo = photo.new(:album_id => params[:album_id])
+  end
+
+  def create
+    @photo = photo.new(params[:photo])
+    if @photo.save
+      flash[:notice] = "Successfully created photo."
+      redirect_to @photo.album
+    else
+      render :action => 'new'
+    end
+  end
+
+  def edit
+    @photo = photo.find(params[:id])
+  end
+
+  def update
+    @photo = photo.find(params[:id])
+    if @photo.update_attributes(params[:photo])
+      flash[:notice] = "Successfully updated photo."
+      redirect_to @photo.album
+    else
+      render :action => 'edit'
+    end
+  end
+
+  def destroy
+    @photo = photo.find(params[:id])
+    @photo.destroy
+    flash[:notice] = "Successfully destroyed photo."
+    redirect_to @photo.album
+  end
+end
diff --git a/app/helpers/albums_helper.rb b/app/helpers/albums_helper.rb
new file mode 100644
index 0000000..2d7ca91
--- /dev/null
+++ b/app/helpers/albums_helper.rb
@@ -0,0 +1,2 @@
+module AlbumsHelper
+end
diff --git a/app/helpers/layout_helper.rb b/app/helpers/layout_helper.rb
new file mode 100755
index 0000000..09fa349
--- /dev/null
+++ b/app/helpers/layout_helper.rb
@@ -0,0 +1,22 @@
+# These helper methods can be called in your template to set variables to be used in the layout
+# This module should be included in all views globally,
+# to do so you may need to add this line to your ApplicationController
+#   helper :layout
+module LayoutHelper
+  def title(page_title, show_title = true)
+    content_for(:title) { h(page_title.to_s) }
+    @show_title = show_title
+  end
+
+  def show_title?
+    @show_title
+  end
+
+  def stylesheet(*args)
+    content_for(:head) { stylesheet_link_tag(*args) }
+  end
+
+  def javascript(*args)
+    content_for(:head) { javascript_include_tag(*args) }
+  end
+end
diff --git a/app/helpers/photos_helper.rb b/app/helpers/photos_helper.rb
new file mode 100644
index 0000000..0a10d47
--- /dev/null
+++ b/app/helpers/photos_helper.rb
@@ -0,0 +1,2 @@
+module PhotosHelper
+end
diff --git a/app/models/album.rb b/app/models/album.rb
new file mode 100755
index 0000000..0fac3e0
--- /dev/null
+++ b/app/models/album.rb
@@ -0,0 +1,4 @@
+class Album < ActiveRecord::Base
+  attr_accessible :name
+  has_many :photos
+end
diff --git a/app/models/photo.rb b/app/models/photo.rb
new file mode 100755
index 0000000..6877afa
--- /dev/null
+++ b/app/models/photo.rb
@@ -0,0 +1,5 @@
+class Photo < ActiveRecord::Base
+  attr_accessible :album_id, :name, :image, :remote_image_url
+  belongs_to :album
+  mount_uploader :image, ImageUploader
+end
diff --git a/app/uploaders/image_uploader.rb b/app/uploaders/image_uploader.rb
new file mode 100755
index 0000000..e311c37
--- /dev/null
+++ b/app/uploaders/image_uploader.rb
@@ -0,0 +1,59 @@
+# encoding: utf-8
+
+class ImageUploader < CarrierWave::Uploader::Base
+
+  # Include RMagick or MiniMagick support:
+  # include CarrierWave::RMagick
+  include CarrierWave::MiniMagick
+
+  # Include the Sprockets helpers for Rails 3.1+ asset pipeline compatibility:
+  # include Sprockets::Helpers::RailsHelper
+  # include Sprockets::Helpers::IsolatedHelper
+
+  # Choose what kind of storage to use for this uploader:
+  storage :file
+  # storage :fog
+
+  # Override the directory where uploaded files will be stored.
+  # This is a sensible default for uploaders that are meant to be mounted:
+  def store_dir
+    "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
+  end
+
+  # Provide a default URL as a default if there hasn't been a file uploaded:
+  # def default_url
+  #   # For Rails 3.1+ asset pipeline compatibility:
+  #   # asset_path("fallback/" + [version_name, "default.png"].compact.join('_'))
+  #
+  #   "/images/fallback/" + [version_name, "default.png"].compact.join('_')
+  # end
+
+  # Process files as they are uploaded:
+  # process :scale => [200, 300]
+  #
+  # def scale(width, height)
+  #   # do something
+  # end
+
+  
+  # Create different versions of your uploaded files:
+  # version :thumb do
+  #   process :scale => [50, 50]
+  # end
+  version :thumb do
+    process :resize_to_limit => [200, 200]
+  end
+
+  # Add a white list of extensions which are allowed to be uploaded.
+  # For images you might use something like this:
+  # def extension_white_list
+  #   %w(jpg jpeg gif png)
+  # end
+
+  # Override the filename of the uploaded files:
+  # Avoid using model.id or version_name here, see uploader/store.rb for details.
+  # def filename
+  #   "something.jpg" if original_filename
+  # end
+
+end
diff --git a/app/views/albums/_form.html.erb b/app/views/albums/_form.html.erb
new file mode 100755
index 0000000..3a1b28e
--- /dev/null
+++ b/app/views/albums/_form.html.erb
@@ -0,0 +1,8 @@
+<%= form_for @album do |f| %>
+  <%= f.error_messages %>
+  <p>
+    <%= f.label :name %><br />
+    <%= f.text_field :name %>
+  </p>
+  <p><%= f.submit %></p>
+<% end %>
diff --git a/app/views/albums/edit.html.erb b/app/views/albums/edit.html.erb
new file mode 100755
index 0000000..6f230ac
--- /dev/null
+++ b/app/views/albums/edit.html.erb
@@ -0,0 +1,8 @@
+<% title "Edit Album" %>
+
+<%= render 'form' %>
+
+<p>
+  <%= link_to "Show", @album %> |
+  <%= link_to "View All", albums_path %>
+</p>
diff --git a/app/views/albums/index.html.erb b/app/views/albums/index.html.erb
new file mode 100755
index 0000000..15854c3
--- /dev/null
+++ b/app/views/albums/index.html.erb
@@ -0,0 +1,10 @@
+<% title "Albums" %>
+
+<% for album in @albums %>
+  <div class="album">
+    <h2><%= link_to album.name, album %></h2>
+    Photos: <%= album.photos.size %>
+  </div>
+<% end %>
+
+<p><%= link_to "New Album", new_album_path %></p>
diff --git a/app/views/albums/new.html.erb b/app/views/albums/new.html.erb
new file mode 100755
index 0000000..16c805a
--- /dev/null
+++ b/app/views/albums/new.html.erb
@@ -0,0 +1,5 @@
+<% title "New Album" %>
+
+<%= render 'form' %>
+
+<p><%= link_to "Back to List", albums_path %></p>
diff --git a/app/views/albums/show.html.erb b/app/views/albums/show.html.erb
new file mode 100755
index 0000000..a380ff5
--- /dev/null
+++ b/app/views/albums/show.html.erb
@@ -0,0 +1,21 @@
+<% title @album.name %>
+
+<div id="photos">
+  <% for photo in @album.photos %>
+    <div class="photo">
+      <%= image_tag photo.image_url(:thumb) if photo.image? %>
+      <div class="name"><%= photo.name %></div>
+      <div class="actions">
+        <%= link_to "edit", edit_photo_path(photo) %> |
+        <%= link_to "remove", photo, :confirm => 'Are you sure?', :method => :delete %>
+      </div>
+    </div>
+  <% end %>
+  <div class="clear"></div>
+</div>
+
+<p>
+  <%= link_to "Add a Photo", new_photo_path(:album_id => @album) %> |
+  <%= link_to "Remove Album", @album, :confirm => 'Are you sure?', :method => :delete %> |
+  <%= link_to "View Albums", albums_path %>
+</p>
diff --git a/app/views/photos/_form.html.erb b/app/views/photos/_form.html.erb
new file mode 100755
index 0000000..15bc6f0
--- /dev/null
+++ b/app/views/photos/_form.html.erb
@@ -0,0 +1,16 @@
+<%= form_for @photo, :html => {:multipart => true} do |f| %>
+  <%= f.error_messages %>
+  <%= f.hidden_field :album_id %>
+  <p>
+    <%= f.label :name %><br />
+    <%= f.text_field :name %>
+  </p>
+  <p>
+    <%= f.file_field :image %>
+  </p>
+  <p>
+    <%= f.label :remote_image_url, "or image URL" %><br />
+    <%= f.text_field :remote_image_url %>
+  </p>
+  <p><%= f.submit %></p>
+<% end %>
diff --git a/app/views/photos/edit.html.erb b/app/views/photos/edit.html.erb
new file mode 100755
index 0000000..0e033b2
--- /dev/null
+++ b/app/views/photos/edit.html.erb
@@ -0,0 +1,5 @@
+<% title "Edit Photo" %>
+
+<%= render 'form' %>
+
+<p><%= link_to "Back to Album", @photo.album %></p>
diff --git a/app/views/photos/new.html.erb b/app/views/photos/new.html.erb
new file mode 100755
index 0000000..50cd2b8
--- /dev/null
+++ b/app/views/photos/new.html.erb
@@ -0,0 +1,5 @@
+<% title "New Photo" %>
+
+<%= render 'form' %>
+
+<p><%= link_to "Back to Album", @photo.album %></p>
diff --git a/config/routes.rb b/config/routes.rb
old mode 100644
new mode 100755
index 3723eaf..587a6a4
--- a/config/routes.rb
+++ b/config/routes.rb
@@ -1,5 +1,9 @@
 Lunker::Application.routes.draw do
 
+  resources :photos
+  resources :albums
+
+
   get "profiles/show"
 
   as :user do
diff --git a/db/migrate/20130206005432_create_albums.rb b/db/migrate/20130206005432_create_albums.rb
new file mode 100644
index 0000000..fc95a21
--- /dev/null
+++ b/db/migrate/20130206005432_create_albums.rb
@@ -0,0 +1,9 @@
+class CreateAlbums < ActiveRecord::Migration
+  def change
+    create_table :albums do |t|
+      t.string :name
+
+      t.timestamps
+    end
+  end
+end
diff --git a/db/migrate/20130206005622_create_photos.rb b/db/migrate/20130206005622_create_photos.rb
new file mode 100644
index 0000000..99dd367
--- /dev/null
+++ b/db/migrate/20130206005622_create_photos.rb
@@ -0,0 +1,10 @@
+class CreatePhotos < ActiveRecord::Migration
+  def change
+    create_table :photos do |t|
+      t.string :name
+      t.integer :album_id
+
+      t.timestamps
+    end
+  end
+end
diff --git a/db/migrate/20130206011657_add_image_to_photos.rb b/db/migrate/20130206011657_add_image_to_photos.rb
new file mode 100644
index 0000000..21dcf02
--- /dev/null
+++ b/db/migrate/20130206011657_add_image_to_photos.rb
@@ -0,0 +1,5 @@
+class AddImageToPhotos < ActiveRecord::Migration
+  def change
+    add_column :photos, :image, :string
+  end
+end
diff --git a/db/schema.rb b/db/schema.rb
index 9a62b7e..b21eef9 100644
--- a/db/schema.rb
+++ b/db/schema.rb
@@ -11,7 +11,21 @@
 #
 # It's strongly recommended to check this file into your version control system.
 
-ActiveRecord::Schema.define(:version => 20130103214502) do
+ActiveRecord::Schema.define(:version => 20130206011657) do
+
+  create_table "albums", :force => true do |t|
+    t.string   "name"
+    t.datetime "created_at", :null => false
+    t.datetime "updated_at", :null => false
+  end
+
+  create_table "photos", :force => true do |t|
+    t.string   "name"
+    t.integer  "album_id"
+    t.datetime "created_at", :null => false
+    t.datetime "updated_at", :null => false
+    t.string   "image"
+  end
 
   create_table "statuses", :force => true do |t|
     t.text     "content"
diff --git a/test/fixtures/albums.yml b/test/fixtures/albums.yml
new file mode 100644
index 0000000..0227c60
--- /dev/null
+++ b/test/fixtures/albums.yml
@@ -0,0 +1,7 @@
+# Read about fixtures at http://api.rubyonrails.org/classes/ActiveRecord/Fixtures.html
+
+one:
+  name: MyString
+
+two:
+  name: MyString
diff --git a/test/fixtures/photos.yml b/test/fixtures/photos.yml
new file mode 100644
index 0000000..6ad657c
--- /dev/null
+++ b/test/fixtures/photos.yml
@@ -0,0 +1,9 @@
+# Read about fixtures at http://api.rubyonrails.org/classes/ActiveRecord/Fixtures.html
+
+one:
+  name: MyString
+  album_id: 1
+
+two:
+  name: MyString
+  album_id: 1
diff --git a/test/functional/albums_controller_test.rb b/test/functional/albums_controller_test.rb
new file mode 100755
index 0000000..adc5b22
--- /dev/null
+++ b/test/functional/albums_controller_test.rb
@@ -0,0 +1,54 @@
+require 'test_helper'
+
+class AlbumsControllerTest < ActionController::TestCase
+  def test_index
+    get :index
+    assert_template 'index'
+  end
+
+  def test_show
+    get :show, :id => Album.first
+    assert_template 'show'
+  end
+
+  def test_new
+    get :new
+    assert_template 'new'
+  end
+
+  def test_create_invalid
+    Album.any_instance.stubs(:valid?).returns(false)
+    post :create
+    assert_template 'new'
+  end
+
+  def test_create_valid
+    Album.any_instance.stubs(:valid?).returns(true)
+    post :create
+    assert_redirected_to album_url(assigns(:album))
+  end
+
+  def test_edit
+    get :edit, :id => Album.first
+    assert_template 'edit'
+  end
+
+  def test_update_invalid
+    Album.any_instance.stubs(:valid?).returns(false)
+    put :update, :id => Album.first
+    assert_template 'edit'
+  end
+
+  def test_update_valid
+    Album.any_instance.stubs(:valid?).returns(true)
+    put :update, :id => Album.first
+    assert_redirected_to album_url(assigns(:album))
+  end
+
+  def test_destroy
+    album = Album.first
+    delete :destroy, :id => album
+    assert_redirected_to albums_url
+    assert !Album.exists?(album.id)
+  end
+end
diff --git a/test/functional/photos_controller_test.rb b/test/functional/photos_controller_test.rb
new file mode 100755
index 0000000..607081a
--- /dev/null
+++ b/test/functional/photos_controller_test.rb
@@ -0,0 +1,54 @@
+require 'test_helper'
+
+class PhotosControllerTest < ActionController::TestCase
+  def test_index
+    get :index
+    assert_template 'index'
+  end
+
+  def test_show
+    get :show, :id => Photo.first
+    assert_template 'show'
+  end
+
+  def test_new
+    get :new
+    assert_template 'new'
+  end
+
+  def test_create_invalid
+    Photo.any_instance.stubs(:valid?).returns(false)
+    post :create
+    assert_template 'new'
+  end
+
+  def test_create_valid
+    Photo.any_instance.stubs(:valid?).returns(true)
+    post :create
+    assert_redirected_to photo_url(assigns(:photo))
+  end
+
+  def test_edit
+    get :edit, :id => Photo.first
+    assert_template 'edit'
+  end
+
+  def test_update_invalid
+    Photo.any_instance.stubs(:valid?).returns(false)
+    put :update, :id => Photo.first
+    assert_template 'edit'
+  end
+
+  def test_update_valid
+    Photo.any_instance.stubs(:valid?).returns(true)
+    put :update, :id => Photo.first
+    assert_redirected_to photo_url(assigns(:photo))
+  end
+
+  def test_destroy
+    photo = Photo.first
+    delete :destroy, :id => photo
+    assert_redirected_to photos_url
+    assert !Photo.exists?(photo.id)
+  end
+end
diff --git a/test/unit/album_test.rb b/test/unit/album_test.rb
new file mode 100755
index 0000000..dca5441
--- /dev/null
+++ b/test/unit/album_test.rb
@@ -0,0 +1,7 @@
+require 'test_helper'
+
+class AlbumTest < ActiveSupport::TestCase
+  def test_should_be_valid
+    assert Album.new.valid?
+  end
+end
diff --git a/test/unit/helpers/albums_helper_test.rb b/test/unit/helpers/albums_helper_test.rb
new file mode 100644
index 0000000..8549abd
--- /dev/null
+++ b/test/unit/helpers/albums_helper_test.rb
@@ -0,0 +1,4 @@
+require 'test_helper'
+
+class AlbumsHelperTest < ActionView::TestCase
+end
diff --git a/test/unit/helpers/photos_helper_test.rb b/test/unit/helpers/photos_helper_test.rb
new file mode 100644
index 0000000..989a82c
--- /dev/null
+++ b/test/unit/helpers/photos_helper_test.rb
@@ -0,0 +1,4 @@
+require 'test_helper'
+
+class PhotosHelperTest < ActionView::TestCase
+end
diff --git a/test/unit/photo_test.rb b/test/unit/photo_test.rb
new file mode 100755
index 0000000..2c415c2
--- /dev/null
+++ b/test/unit/photo_test.rb
@@ -0,0 +1,7 @@
+require 'test_helper'
+
+class PhotoTest < ActiveSupport::TestCase
+  def test_should_be_valid
+    assert Photo.new.valid?
+  end
+end
