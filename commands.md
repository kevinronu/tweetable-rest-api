rails new . --database postgresql --skip-test

--Update Gemfile
disable gem "jbuilder"
enable gem "bcrypt"

rails g scaffold User name username:string:uniq email:string:uniq password_digest:string:uniq role:integer
-- Modify migration: t.integer :role, default: 0

rails g scaffold Tweet body:text replies_count:integer likes_count:integer user:references replied_to:references
-- Modify migration: t.integer :replies_count, default: 0
t.integer :likes_count, default: 0
t.references :replied_to, null: true, foreign_key: { to_table: :tweets }

rails g model Like user:references tweet:references

rails g controller likes create show destroy

rails g migration AddIndexUserTweetToLike
-- Modify migration: add_index :likes, [:user_id, :tweet_id], unique: true

rails active_storage:install
