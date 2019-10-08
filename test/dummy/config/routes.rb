Rails.application.routes.draw do
  get 'books/index'
  get 'books/not_index'
  get 'books/another_action'
  get 'books/xhr_remember_action'
end
