require_relative '../rails_helper'

describe PostsController do
  render_views

  let!(:foo_post) { Post.create title: "Foo", body: "This is Foo" }
  let!(:bar_post) { Post.create title: "Bar", body: "That is Bar" }

  describe "single file rendering" do
    it "loads jBuilder" do
      expect(ActionView::Template::Handlers.extensions).to eq [:raw, :erb, :html, :builder, :ruby, :jbuilder]
    end

    it "render a list of posts" do
      request.accept = "application/json"
      get :index, format: :json
      expect(response.body).to include "Foo", "Bar"
    end
  end
end
