require 'rails_helper'

RSpec.describe "/comments", type: :request do
  let(:user) { create(:user) }
  let(:post) { create(:post) }

  let(:valid_attributes) { attributes_for(:comment, post_id: post.id) }

  let(:invalid_attributes) {
    attributes_for(:comment, post_id: nil)
  }

  describe "GET /index" do
    it "renders a successful response" do
      Comment.create! valid_attributes
      get comments_url, headers: auth_header(user), as: :json
      expect(response).to be_successful
    end
  end

  describe "GET /show" do
    it "renders a successful response" do
      comment = Comment.create! valid_attributes
      get comment_url(comment), headers: auth_header(user), as: :json
      expect(response).to be_successful
    end
  end

  describe "POST /create" do
    context "with valid parameters" do
     
      it "creates a new Comment" do
        expect {
          post comments_url,
               params: { comment: valid_attributes }, headers: auth_header(user), as: :json
        }.to change(Comment, :count).by(1)
      end

      it "renders a JSON response with the new comment" do
        post comments_url,
             params: { comment: valid_attributes }, headers: auth_header(user), as: :json
        expect(response).to have_http_status(:created)
        expect(response.content_type).to match(a_string_including("application/json"))
      end
    end

    context "with invalid parameters" do
      it "does not create a new Comment" do
        expect {
          post comments_url,
               params: { comment: invalid_attributes }, headers: auth_header(user), as: :json
        }.to change(Comment, :count).by(0)
      end

      it "renders a JSON response with errors for the new comment" do
        post comments_url,
             params: { comment: invalid_attributes }, headers: auth_header(user), as: :json
        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.content_type).to match(a_string_including("application/json"))
      end
    end
  end

  describe "PATCH /update" do
    context "with valid parameters" do
      let(:new_name) { 'My new name' }
      let(:new_attributes) {
        attributes_for(:comment, name: new_name)
      }

      it "updates the requested comment" do
        comment = Comment.create! valid_attributes
        patch comment_url(comment),
              params: { comment: new_attributes }, headers: auth_header(user), as: :json
        comment.reload
        expect(comment.name).to eq new_name
      end

      it "renders a JSON response with the comment" do
        comment = Comment.create! valid_attributes
        patch comment_url(comment),
              params: { comment: new_attributes }, headers: auth_header(user), as: :json
        expect(response).to have_http_status(:ok)
        expect(response.content_type).to match(a_string_including("application/json"))
      end
    end

    context "with invalid parameters" do
      it "renders a JSON response with errors for the comment" do
        comment = Comment.create! valid_attributes
        patch comment_url(comment),
              params: { comment: invalid_attributes }, headers: auth_header(user), as: :json
        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.content_type).to match(a_string_including("application/json"))
      end
    end
  end

  describe "DELETE /destroy" do
    it "destroys the requested comment" do
      comment = Comment.create! valid_attributes
      expect {
        delete comment_url(comment), headers: auth_header(user), as: :json
      }.to change(Comment, :count).by(-1)
    end
  end
end
