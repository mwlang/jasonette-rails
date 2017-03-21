require_relative '../rails_helper'

describe PostsController do
  render_views

  let!(:post) { Post.create title: "Foo", body: "Bar" }

  describe "single file rendering" do
    it "render a list of posts" do
      expect(ActionView::Template::Handlers.extensions).to eq [:raw, :erb, :html, :builder, :ruby, :jbuilder]
      request.accept = "application/json"
      get :index, format: :json
      expect(response.body).to eq "foo"
    end
  end
end
