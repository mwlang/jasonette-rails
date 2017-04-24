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
      expect(JSON.parse(response.body)).to eq({"$jason"=>{"body"=>{"sections"=>[{"items"=>[{"text"=>"Foo", "type"=>"label"}, {"text"=>"Bar", "type"=>"label"}]}]}}})
    end

    it "render a list of posts" do
      request.accept = "application/json"
      get :partial, format: :json
      expect(JSON.parse(response.body)).to eq({"$jason"=>{"body"=>{"sections"=>[{"type"=>"partial", "items"=>[{"text"=>"Foo", "type"=>"label"}, {"text"=>"Bar", "type"=>"label"}]}]}, "foo"=>"bar"}})
    end

    it "can call helper methods" do
      request.accept = "application/json"
      get :helper, format: :json
      expect(JSON.parse(response.body)).to eq({"$jason"=>{"head"=>{"data"=>{"foo"=>"foo", "app_foo"=>"app_foo", "post_foo"=>"post_foo", "block_foo"=>"app_foo_with_block"}}}})
    end

    let(:action_partial_json) do
      { "$jason" => {
          "head" => {
            "title" => "Matchpoint",
            "actions" => {
              "$foreground" => { "type" => "$reload" },
              "$pull" => { "type" => "$reload" },
              "$load" => { "trigger" => "onload", "success" => { "type" => "$render" } },
              "onload" => {
                "type" => "$set",
                "options" => { "authenticity_token" => "form_authenticity_token" },
                "success" => { "trigger" => "set_score" },
              },
            }
          }
        }
      }
    end

    it "render a partial within an action" do
      request.accept = "application/json"
      get :action_partial, format: :json

      expect(JSON.parse(response.body)).to eq action_partial_json
    end

    it "render an action within a partial" do
      request.accept = "application/json"
      get :action_in_partial, format: :json

      expect(JSON.parse(response.body)).to eq action_partial_json
    end

    it "render a list of posts" do
      request.accept = "application/json"
      get :inline, format: :json
      expect(JSON.parse(response.body)).to eq({"$jason"=>{"body"=>{"sections"=>[{"type"=>"inline", "items"=>[{"text"=>"Foo", "type"=>"label"}, {"text"=>"Bar", "type"=>"label"}]}]}}})
    end
  end

  describe "mix rendering" do
    it "render a list of posts" do
      request.accept = "application/json"
      get :mixing, format: :json
      expect(JSON.parse(response.body)).to eq({"$jason"=>{"body"=>{"sections"=>[
        {"type"=>"partial", "items"=>[{"text"=>"Foo", "type"=>"label"}, {"text"=>"Bar", "type"=>"label"}]},
        {"type"=>"inline", "items"=>[{"text"=>"Foo", "type"=>"label"}, {"text"=>"Bar", "type"=>"label"}]}
      ]}}})
    end
  end
end
