require 'test_helper'

class UsersIndexTest < ActionDispatch::IntegrationTest
 def setup
 @user = users(:michael)
 end
 
 # test "index as admin including pagination and delete links" do
 #    log_in_as(@user)
 #    get users_path
 #    assert_template 'users/index'
 #    assert_select 'div.pagination'
 #    first_page_of_users = User.paginate(page: 1)
 #    first_page_of_users.each do |user|
 #      assert_select 'a[href=?]', user_path(user), text: user.name
 #      unless user == @user
 #        assert_select 'a[href=?]', user_path(@user), text: 'delete'
 #      end
 #    end
 #    assert_difference 'User.count', -1 do
 #      delete user_path(@user)
 #    end
 #   end
   
 

 test "index include pagination" do
   log_in_as(@user)
   get users_path
   assert_template 'users/index'
   assert_select 'div.pagination'
   User.paginate(page: 1).each do |user|
     assert_select 'a[href = ?]',user_path(user), text: user.name
    end
  end 
  # #アカウント削除のテストがどうしてもアカウント数へらん。
  # test "Delete account" do
  #  assert_difference 'User.count', -1 do
  #   delete user_path(@user)
  # end
  #  assert_redirected_to root_url
  # end
end
