class BooksController < ApplicationController
  remember_params :foo, :bar
  remember_params :foo, :bar, on: :another_action, duration: 10.seconds

  def index
    head :ok
  end

  def not_index
    head :ok
  end

  def another_action
    head :ok
  end
end
