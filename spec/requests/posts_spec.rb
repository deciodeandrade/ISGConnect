require 'rails_helper'

RSpec.describe "/posts", type: :request do
  let(:user) { create(:user) }

  let(:valid_attributes) { attributes_for(:post, user_id: user.id) }

  let(:invalid_attributes) {
    attributes_for(:post, title: nil)
  }

  describe "GET /index" do
    it "renders a successful response" do
      Post.create! valid_attributes
      get posts_url, headers: auth_header(user), as: :json
      expect(response).to be_successful
    end
  end

  describe "GET /show" do
    it "renders a successful response" do
      post = Post.create! valid_attributes
      get post_url(post), headers: auth_header(user), as: :json
      expect(response).to be_successful
    end
  end

  describe "POST /create" do
    context "with valid parameters" do
      it "creates a new Post" do
        expect {
          post posts_url,
               params: { post: valid_attributes }, headers: auth_header(user), as: :json
        }.to change(Post, :count).by(1)
      end

      it "renders a JSON response with the new post" do
        post posts_url,
             params: { post: valid_attributes }, headers: auth_header(user), as: :json
        expect(response).to have_http_status(:ok)
        expect(response.content_type).to match(a_string_including("application/json"))
      end
    end

    context "with invalid parameters" do
      it "does not create a new Post" do
        expect {
          post posts_url,
               params: { post: invalid_attributes }, as: :json
        }.to change(Post, :count).by(0)
      end

      it "renders a JSON response with errors for the new post" do
        post posts_url,
             params: { post: invalid_attributes }, headers: auth_header(user), as: :json
        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.content_type).to match(a_string_including("application/json"))
      end
    end
  end

  describe "PATCH /update" do
    context "with valid parameters" do
      let(:new_title) { 'My new title' }
      let(:new_attributes) {
        attributes_for(:post, title: new_title)
      }

      it "updates the requested post" do
        post = Post.create! valid_attributes
        patch post_url(post),
              params: { post: new_attributes }, headers: auth_header(user), as: :json
        post.reload
        expect(post.title).to eq new_title
      end

      it "renders a JSON response with the post" do
        post = Post.create! valid_attributes
        patch post_url(post),
              params: { post: new_attributes }, headers: auth_header(user), as: :json
        expect(response).to have_http_status(:ok)
        expect(response.content_type).to match(a_string_including("application/json"))
      end
    end

    context "with invalid parameters" do
      it "renders a JSON response with errors for the post" do
        post = Post.create! valid_attributes
        patch post_url(post),
              params: { post: invalid_attributes }, headers: auth_header(user), as: :json
        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.content_type).to match(a_string_including("application/json"))
      end
    end
  end

  describe "DELETE /destroy" do
    it "destroys the requested post" do
      post = Post.create! valid_attributes
      expect {
        delete post_url(post), headers: auth_header(user), as: :json
      }.to change(Post, :count).by(-1)
    end
  end
end
