# == Schema Information
#
# Table name: user_filters
#
#  id         :integer(4)      not null, primary key
#  user_id    :integer(4)
#  table_name :string(255)
#  created_at :datetime
#  updated_at :datetime
#

class UserFilter < ActiveRecord::Base

  has_many :user_filter_columns

  def self.create_modified user, default_filter, columns
    matched_columns = DefaultFilterColumn.where(:default_filter_id => default_filter.id, :column_name =>  columns).all
    filter = UserFilter.where(:user_id => user.id, :table_name => default_filter.table_name).first
    if filter.nil?
      filter = UserFilter.new(:user_id => user.id, :table_name => default_filter.table_name)
      filter.save
    end
    UserFilterColumn.delete(UserFilterColumn.where(:user_filter_id => filter.id).all)
    matched_columns.each do |column|
      filter.user_filter_columns<<UserFilterColumn.new(
          :column_name => column.column_name,
          :column_type => column.column_type,
          :column_query => column.column_query,
          :column_position => column.column_position
      )
    end
  end

  def self.reset_filter user, name
    filter = UserFilter.where(:user_id => user.id, :table_name => name).first
    unless filter.nil?
      UserFilterColumn.delete(UserFilterColumn.where(:user_filter_id => filter.id).all)
      UserFilter.delete(filter)
    end
  end
end
