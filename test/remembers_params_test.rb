require 'test_helper'

class BooksControllerTest < ActionDispatch::IntegrationTest
  test 'saves and restores params' do
    get books_index_path, params: { foo: 1, bar: 2 }
    get books_index_path
    assert_redirected_to books_index_path(foo: 1, bar: 2)
  end

  test 'overwrites remembered params' do
    get books_index_path, params: { foo: 1, bar: 2 }
    get books_index_path, params: { foo: 3 }
    get books_index_path
    assert_redirected_to books_index_path(foo: 3)
  end

  test 'resets all params' do
    get books_index_path, params: { foo: 1, bar: 2 }
    get books_index_path, params: { reset_params: true }
    follow_redirect!
    assert_equal path, books_index_path # reset_params is gone
    get books_index_path
    assert_response :success # no redirect
  end

  test 'only saves specified params' do
    get books_index_path, params: { foo: 1, bar: 2, baz: 3 }
    get books_index_path
    assert_redirected_to books_index_path(foo: 1, bar: 2)
  end

  test 'does not save params on unwanted actions' do
    get books_not_index_path, params: { foo: 1, bar: 2 }
    get books_not_index_path
    assert_response :success # no redirect
  end

  test 'works for other specified actions' do
    get books_another_action_path, params: { foo: 1, bar: 2 }
    get books_another_action_path
    assert_redirected_to books_another_action_path(foo: 1, bar: 2)
  end

  test 'does not save params on xhr requests' do
    get books_index_path, xhr: true, params: { foo: 1, bar: 2 }
    get books_index_path, xhr: true
    assert_response :success # no redirect
  end

  test 'invalidates remembered params after specified duration' do
    get books_index_path, params: { foo: 1, bar: 2 }
    Timecop.travel(DateTime.now+2.hours)
    get books_index_path
    assert_response :success # no redirect
  end

  test 'refreshes rememered_at' do
    get books_index_path, params: { foo: 1, bar: 2 }
    Timecop.travel(DateTime.now+40.minutes)
    get books_index_path # refresh
    follow_redirect!
    Timecop.travel(DateTime.now+40.minutes)
    get books_index_path
    assert_redirected_to books_index_path(foo: 1, bar: 2)
  end
end
