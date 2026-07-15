require 'rails_helper'

RSpec.describe "ApplicationController", type: :request do
  let(:user) { create(:user) }

  before { sign_in user }

  it "returns 404 status" do
    get project_path(SecureRandom.uuid)

    expect(response).to have_http_status(:not_found)
  end

  it "returns 500 status" do
    allow_any_instance_of(ProjectsController).to receive(:index).and_raise(StandardError)

    get projects_path

    expect(response).to have_http_status(:internal_server_error)
  end
end
