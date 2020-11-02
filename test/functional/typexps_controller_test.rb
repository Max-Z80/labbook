require 'test_helper'

class TypexpsControllerTest < ActionController::TestCase
  def test_should_get_index
    get :index
    assert_response :success
    assert_not_nil assigns(:typexps)
  end

  def test_should_get_new
    get :new
    assert_response :success
  end

  def test_should_create_typexp
    assert_difference('Typexp.count') do
      post :create, :typexp => { }
    end

    assert_redirected_to typexp_path(assigns(:typexp))
  end

  def test_should_show_typexp
    get :show, :id => typexps(:one).id
    assert_response :success
  end

  def test_should_get_edit
    get :edit, :id => typexps(:one).id
    assert_response :success
  end

  def test_should_update_typexp
    put :update, :id => typexps(:one).id, :typexp => { }
    assert_redirected_to typexp_path(assigns(:typexp))
  end

  def test_should_destroy_typexp
    assert_difference('Typexp.count', -1) do
      delete :destroy, :id => typexps(:one).id
    end

    assert_redirected_to typexps_path
  end
end
