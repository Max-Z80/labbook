require 'test_helper'

class DocsControllerTest < ActionController::TestCase
  def test_should_get_index
    get :index
    assert_response :success
    assert_not_nil assigns(:docs)
  end

  def test_should_get_new
    get :new
    assert_response :success
  end

  def test_should_create_doc
    assert_difference('Doc.count') do
      post :create, :doc => { }
    end

    assert_redirected_to doc_path(assigns(:doc))
  end

  def test_should_show_doc
    get :show, :id => docs(:one).id
    assert_response :success
  end

  def test_should_get_edit
    get :edit, :id => docs(:one).id
    assert_response :success
  end

  def test_should_update_doc
    put :update, :id => docs(:one).id, :doc => { }
    assert_redirected_to doc_path(assigns(:doc))
  end

  def test_should_destroy_doc
    assert_difference('Doc.count', -1) do
      delete :destroy, :id => docs(:one).id
    end

    assert_redirected_to docs_path
  end
end
