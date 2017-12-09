class Admin < ApplicationRecord
  has_secure_password
  mount_uploader :avatar, AvatarUploader

  validates_presence_of :name,:lastname,:email,:password
  validates_format_of :email, with: /\A[^@\s]+@[^@\s]+\z/
  validates_length_of :password, minimum: 8
  validates_length_of :name,:lastname, minimum: 3

  def self.load(page: 1, per_page: 10)
    paginate(page: page, per_page: per_page)
  end

  def self.by_id(id)
    find_by_id(id)
  end

  def self.by_email(email)
    find_by_email(email)
  end

end
