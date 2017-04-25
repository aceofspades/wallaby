module Wallaby
  # Secure helper
  module SecureHelper
    def user_portrait(user = current_user)
      if user.respond_to? :email
        https = "http#{request.ssl? ? 's' : EMPTY_STRING}"
        email_md5 = Digest::MD5.hexdigest user.email.downcase
        image_source = "#{https}://www.gravatar.com/avatar/#{email_md5}"
        image_tag image_source, class: 'hidden-xs user-portrait'
      else
        content_tag :i, nil, class: 'glyphicon glyphicon-user user-portrait'
      end
    end

    def logout_path(user = current_user, app = main_app)
      path =
        if defined? Devise
          scope = Devise::Mapping.find_scope! user
          "destroy_#{scope}_session_path"
        else
          'logout_path'
        end
      app.public_send path if app.respond_to? path
    end

    def logout_method
      method = Array(Devise.sign_out_via).first if defined? Devise
      method || :delete
    end
  end
end