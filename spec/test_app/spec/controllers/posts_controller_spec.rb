require_relative '../rails_helper'

describe PostsController do
  render_views

  let!(:foo_post) { Post.create title: "Foo", body: "This is Foo" }
  let!(:bar_post) { Post.create title: "Bar", body: "That is Bar" }

  describe "rendering" do
    it "loads jBuilder" do
      expect(ActionView::Template::Handlers.extensions).to eq [:raw, :erb, :html, :builder, :ruby, :jasonette]
    end

    it "builds @posts" do
      request.accept = "application/json"
      get :index, format: :json
      expect(JSON.parse(response.body)).to eq({"$jason"=>{"body"=>{
        "sections"=>[{"items"=>[{"text"=>"Foo", "type"=>"label"}, {"text"=>"Bar", "type"=>"label"}]}]}}})
    end

    context "partial!" do
      it "builds @posts" do
        request.accept = "application/json"
        get :partial, format: :json
        expect(JSON.parse(response.body)["$jason"]["body"]["sections"]).to include "type"=>"partial",
          "items"=>[{"text"=>"Foo", "type"=>"label"}, {"text"=>"Bar", "type"=>"label"}]
        expect(JSON.parse(response.body)["$jason"]).to include "foo"=>"bar"
      end

      let(:action_partial_json) do
        {
          "$jason" => {
            "head" => {
              "title" => "Matchpoint",
              "actions" => {
                "$foreground" => { "type" => "$reload" },
                "$pull" => { "type" => "$reload" },
                "$load" => { "trigger" => "onload", "success" => { "type" => "$render" } },
                "onload" => { "type" => "$set",
                  "options" => { "authenticity_token" => "form_authenticity_token" },
                  "success" => { "trigger" => "set_score" }
                }
              }
            }
          }
        }
      end

      it "builds template methods into an action" do
        request.accept = "application/json"
        get :action_partial, format: :json

        expect(JSON.parse(response.body)).to eq action_partial_json
      end

      it "builds  an action in partial" do
        request.accept = "application/json"
        get :action_in_partial, format: :json

        expect(JSON.parse(response.body)).to eq action_partial_json
      end
    end
  end

  describe "render" do
    context "without layout" do
      it "builds only template" do
        request.accept = "application/json"
        get :without_layout, format: :json
        expect(JSON.parse(response.body)).to eq("$jason" => {"foo"=>"in template"})
      end
    end

    context "with layout" do
      describe "to have requests in multi threaded" do
        let(:thr1) do
          Thread.new do
            Thread.current[:sleepee] = true
            get :with_layout, format: :json
          end
        end

        let(:thr2) do
          Thread.new do
            st = true
            while st do
              thr1.status == "run" ? sleep(0.1) : (st = false)
            end
            Thread.current[:sleepee] = false
            get :with_layout, format: :json
          end
        end

        context "with changed shared resource(`JasonSingleton instances`) in between threads" do
          it "raise error" do
            thr2.join

            expect do
              if thr1.status == "sleep"
                Jasonette::JasonSingleton.class_variable_get('@@instances').first.__locals = nil
                thr1.wakeup; thr1.join
              end
            end.to raise_error StandardError
          end
        end

        context "without changed shared resource(`JasonSingleton instances`) in between threads" do
          it "not raise error" do
            thr2.join

            expect do
              if thr1.status == "sleep"
                thr1.wakeup; thr1.join
              end
            end.not_to raise_error
          end
        end
      end

      it "builds layout and template" do
        request.accept = "application/json"
        get :with_layout, format: :json
        expect(JSON.parse(response.body)).to eq("$jason" => {"head"=>{"layout_local_var"=>"new_post", "foo"=>"in template", "template_local_var"=>"new_post"}})
      end

      it "builds template with local template variables" do
        request.accept = "application/json"
        get :with_template_vars, format: :json, params: { template_vars: ["foo", "bar"] }
        expect(JSON.parse(response.body)).to eq("$jason"=>{"head"=>{"foo"=>"in template", "template_var_foo"=>"foo", "template_var_bar"=>"bar", "template_var_baz"=>"baz"}})
      end
    end
  end

  describe "calling helpers" do
    it "builds helper" do
      request.accept = "application/json"
      get :helper, format: :json
      expect(JSON.parse(response.body)["$jason"]["head"]).to include "data"=>{"foo"=>"foo", "app_foo"=>"app_foo", "post_foo"=>"post_foo", "block_foo"=>"app_foo_with_block"}
    end

    it "builds without calling helper" do
      request.accept = "application/json"
      get :helper, format: :json
      expect(JSON.parse(response.body)["$jason"]["head"]).to include "styles"=>{"post_foo"=>{"color"=>"white"}}
    end

    it "builds only public helper" do
      request.accept = "application/json"
      get :helper, format: :json
      expect(JSON.parse(response.body)["$jason"]["head"]).to include "private_posts"=>["post"], "public_helper_posts"=>["post"]
    end

    context "have jason_builder" do
      it "builds builder attributes" do
        request.accept = "application/json"
        get :helper, format: :json
        expect(JSON.parse(response.body)["$jason"]["head"]).to include "actions" => {"test"=>{"success"=>{"type"=>"$render"}}}
      end

      it "builds block with template methods" do
        request.accept = "application/json"
        get :helper, format: :json, params: { has_block: true }
        expect(JSON.parse(response.body)["$jason"]["body"]).to include "sections"=>[{"items"=>[{"type"=>"space", "height"=>"10", "foo"=>"bar"}]}]
      end

      it "builds no need block" do
        request.accept = "application/json"
        get :helper, format: :json, params: { has_block: false }
        expect(JSON.parse(response.body)["$jason"]["body"]).to include "sections"=>[{"items"=>[{"type"=>"space", "height"=>"10"}]}]
      end
    end
  end

  describe "#as_json use" do
    context "without defination of as_json", shared_context: :remove_as_json do
      it "build wrong target!" do
        expect { get :as_json, format: :json }.to raise_error ActionView::Template::Error, "not opened for reading"
      end
    end

    context "with defination of as_json" do
      it "build target!" do
        request.accept = "application/json"
        get :as_json, format: :json
        expect(JSON.parse(response.body)["$jason"]).to include "head" => {"as_json"=>[{"actions"=>{"test"=>{"success"=>{"type"=>"$render"}}}}]}
      end
    end
  end
end
