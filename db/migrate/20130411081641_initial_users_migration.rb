class InitialUsersMigration < ActiveRecord::Migration
  def change
    create_table "authentications" do |t|
      t.integer "user_id"
      t.string  "provider"
      t.string  "uid"
    end

    add_index "authentications", ["provider"], name: "index_authentications_on_provider"
    add_index "authentications", ["uid"], name: "index_authentications_on_uid"

    create_table "users" do |t|
      t.string   "email"
      t.string   "encrypted_password",   limit: 128, default: "",    null: false
      t.string   "password_salt",                    default: "",    null: false
      t.string   "reset_password_token"
      t.string   "remember_token"
      t.datetime "remember_created_at"
      t.integer  "sign_in_count",                    default: 0
      t.datetime "current_sign_in_at"
      t.datetime "last_sign_in_at"
      t.string   "current_sign_in_ip"
      t.string   "last_sign_in_ip"
      t.string   "name"
      t.string   "address"
      t.string   "phone"
      t.string   "aim"
      t.string   "jabber"
      t.string   "skype"
      t.float    "latitude"
      t.float    "longitude"
      t.datetime "created_at"
      t.datetime "updated_at"
      t.string   "yim"
      t.boolean  "show_email",                       default: false
      t.string   "country"
    end

    add_index "users", ["email"], name: "index_users_on_email", unique: true
    add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end
end
