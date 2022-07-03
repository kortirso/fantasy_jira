# frozen_string_literal: true

module Authentication
  extend ActiveSupport::Concern

  included do
    before_action :current_user
  end

  private

  def current_user
    Current.user ||= User.find_by(id: session[:fantasy_jira_user_id]) if session[:fantasy_jira_user_id]
  end

  def authenticate
    return if Current.user

    redirect_to users_login_path, alert: t('controllers.authentication.permission')
  end
end
