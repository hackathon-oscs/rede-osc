require File.dirname(__FILE__) + '/../test_helper'
require 'favorite_enterprises_controller'

class FavoriteEnterprisesController; def rescue_action(e) raise e end; end

class FavoriteEnterprisesControllerTest < ActionController::TestCase

  noosfero_test :profile => 'testuser'

  def setup
    @controller = FavoriteEnterprisesController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new

    self.profile = create_user('testuser').person
    self.favorite_enterprise = fast_create(Enterprise, :name => 'the_enterprise', :identifier => 'the_enterprise')
    login_as ('testuser')
  end
  attr_accessor :profile, :favorite_enterprise

  def test_local_files_reference
    assert_local_files_reference
  end
  
  def test_valid_xhtml
    assert_valid_xhtml
  end
  
  should 'list favorite enterprises' do
    get :index
    assert_response :success
    assert_template 'index'
    assert_kind_of Array, assigns(:favorite_enterprises)
  end

  should 'confirm addition of new favorite enterprise' do
    get :add, :id => favorite_enterprise.id

    assert_response :success
    assert_template 'add'

    ok("must load the favorite enterprise being added to display") { favorite_enterprise == assigns(:favorite_enterprise) } 

  end

  should 'actually add favorite_enterprise' do
    assert_difference profile.favorite_enterprises, :count do
      post :add, :id => favorite_enterprise.id, :confirmation => '1'
      assert_response :redirect

      profile.favorite_enterprises.reload
    end
  end

  should 'confirm removal of favorite enterprise' do
    profile.favorite_enterprises << favorite_enterprise

    get :remove, :id => favorite_enterprise.id
    assert_response :success
    assert_template 'remove'
    ok("must load the favorite_enterprise being removed") { favorite_enterprise == assigns(:favorite_enterprise) }
  end

  should 'actually remove favorite_enterprise' do
    profile.favorite_enterprises << favorite_enterprise

    assert_difference profile.favorite_enterprises, :count, -1 do
      post :remove, :id => favorite_enterprise.id, :confirmation => '1'
      assert_redirected_to :action => 'index'

      profile.favorite_enterprises.reload
    end
  end

end
