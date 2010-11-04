ActiveRecord::Schema.define(:version => 20091209) do

  create_table "albuns",   :force => true do |t|
    t.string   "nome",        :limit => 55, :null => false
    t.string   "atalho",     :limit => 55, :null => false
    t.string   "image_url", :null => false
    t.integer   "ano",          :null => false
    t.integer  "banda_id", :limit => 6, :null => false
    t.integer  "user_id",   :limit => 6, :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end
  add_index :albuns, :atalho

  create_table "bandas", :force => true do |t|
    t.string   "nome",      :limit => 55, :null => false
    t.string   "atalho",   :limit => 55, :null => false
    t.integer  "user_id", :limit => 6, :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end
  add_index :bandas, :atalho
  #...
  
  create_table "links",      :force => true do |t|
    t.string   "url",           :null => false
    t.belongs_to  "album",  :limit => 6, :null => false
    t.integer  "user_id",    :limit => 6, :null => false
    t.belongs_to  "tracker"
    t.belongs_to  "torrent"
    t.boolean "is_torrent", :default=>false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "votos",          :force => true do |t|
    t.integer  "link_id",        :limit => 6, :null => false
    t.integer   "user_id",       :limit => 6, :null => false
    t.integer   "ponto",          :limit => 1, :null => false
    t.string     "comentario",  :null => false
    t.datetime "created_at"
  end

  create_table "users",         :force => true do |t|
    t.string   "username",      :limit => 15, :null => false
    t.string   "normalizado", :limit => 15, :null => false
    t.string   "email",           :null => false
    t.string   "senha",           :limit => 15, :null => false
    t.string   "info"
    t.integer	"confirmado",   :default=>0, :null => false        
    t.datetime "lastlogin_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end
  add_index :users, :username

  create_table "torrents", :force => true do |t|
    t.string   "nome",          :limit => 60, :null => false
    t.string   "fixhash",     :limit => 40, :null => false
    t.integer "size",          :null => false
    t.datetime "created_at"
  end
  add_index :torrents, :fixhash

  create_table "trackers", :force => true do |t|
    t.string   "nome",     :limit => 80, :null => false
    t.string   "url",       :null => false
    t.boolean "is_torrent", :default=>false
    t.datetime "created_at"
  end
  add_index :trackers, :url

#  create_table "pieces", :force => true do |t|
#    t.integer "torrent_id",  :null => false
#    t.text :pieces, :null => false
#    t.integer :length, :null => false
#  end

  create_table "arquivos", :force => true do |t|
    t.integer "torrent_id", :null => false
    t.string   "nome",      :null => false
    t.string   "pasta"
    t.integer "size", :null => false
  end

  create_table "torrents_trackers", :force => true do |t|
    t.integer "torrent_id", :null => false
    t.integer "tracker_id", :null => false
    t.integer   "seeds",     :limit => 6, :null => false
    t.integer   "leechs",     :limit => 6, :null => false
    t.datetime "updated_at"
    t.datetime "created_at"
  end

  User.create(:username => 'polo', :info=> "aways over here", :email => "polo@mostre.me", :senha=>"polopolo", :confirmado=>1)

end