class AddTokenToUser < ActiveRecord::Migration
  def change
    add_column :users, :token, :string, unique: true
    User.all.each do |user|
      user.token = Devise.friendly_token
      user.save
    end
  end
end
