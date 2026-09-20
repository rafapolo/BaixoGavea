# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[8.1].define(version: 2026_09_20_160826) do
  create_table "albums", force: :cascade do |t|
    t.integer "ano"
    t.string "atalho"
    t.integer "banda_id", null: false
    t.datetime "created_at", null: false
    t.string "image_url"
    t.string "nome"
    t.datetime "updated_at", null: false
    t.integer "user_id", null: false
    t.index ["banda_id"], name: "index_albums_on_banda_id"
    t.index ["user_id"], name: "index_albums_on_user_id"
  end

  create_table "bandas", force: :cascade do |t|
    t.string "atalho"
    t.datetime "created_at", null: false
    t.string "nome"
    t.datetime "updated_at", null: false
    t.integer "user_id", null: false
    t.index ["atalho"], name: "index_bandas_on_atalho", unique: true
    t.index ["nome"], name: "index_bandas_on_nome", unique: true
    t.index ["user_id"], name: "index_bandas_on_user_id"
  end

  create_table "links", force: :cascade do |t|
    t.integer "album_id", null: false
    t.datetime "created_at", null: false
    t.boolean "is_torrent"
    t.integer "torrent_id"
    t.integer "tracker_id"
    t.datetime "updated_at", null: false
    t.string "url"
    t.integer "user_id", null: false
    t.index ["album_id"], name: "index_links_on_album_id"
    t.index ["torrent_id"], name: "index_links_on_torrent_id"
    t.index ["tracker_id"], name: "index_links_on_tracker_id"
    t.index ["user_id"], name: "index_links_on_user_id"
  end

  create_table "torrents", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "fixhash"
    t.string "nome"
    t.integer "size"
    t.datetime "updated_at", null: false
    t.index ["fixhash"], name: "index_torrents_on_fixhash", unique: true
  end

  create_table "trackers", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.boolean "is_torrent"
    t.string "nome"
    t.datetime "updated_at", null: false
    t.string "url"
    t.index ["url"], name: "index_trackers_on_url", unique: true
  end

  create_table "users", force: :cascade do |t|
    t.boolean "confirmado"
    t.datetime "created_at", null: false
    t.string "email"
    t.text "info"
    t.datetime "lastlogin_at"
    t.string "normalizado"
    t.string "password_digest"
    t.datetime "updated_at", null: false
    t.string "username"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["normalizado"], name: "index_users_on_normalizado", unique: true
    t.index ["username"], name: "index_users_on_username", unique: true
  end

  create_table "votos", force: :cascade do |t|
    t.text "comentario"
    t.datetime "created_at", null: false
    t.integer "link_id", null: false
    t.integer "ponto"
    t.datetime "updated_at", null: false
    t.integer "user_id", null: false
    t.index ["link_id"], name: "index_votos_on_link_id"
    t.index ["user_id"], name: "index_votos_on_user_id"
  end

  add_foreign_key "albums", "bandas"
  add_foreign_key "albums", "users"
  add_foreign_key "bandas", "users"
  add_foreign_key "links", "albums"
  add_foreign_key "links", "torrents"
  add_foreign_key "links", "trackers"
  add_foreign_key "links", "users"
  add_foreign_key "votos", "links"
  add_foreign_key "votos", "users"
end
