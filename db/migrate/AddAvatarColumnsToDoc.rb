#ajout perso pour plugin paperclip
  class AddAvatarColumnsToDocs < ActiveRecord::Migration
    def self.up
      add_column :docs, :avatar_file_name,    :string
      add_column :docs, :avatar_content_type, :string
      add_column :docs, :avatar_file_size,    :integer
      add_column :docs, :avatar_updated_at,   :datetime
    end

    def self.down
      remove_column :docs, :avatar_file_name
      remove_column :docs, :avatar_content_type
      remove_column :docs, :avatar_file_size
      remove_column :docs, :avatar_updated_at
    end
  end
