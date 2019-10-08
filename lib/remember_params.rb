module RememberParams
  extend ActiveSupport::Concern

  included do
    before_action :restore_or_save_params

    def self.remember_params(*params, on: :index, duration: 1.hour, xhr: false)
      on = on.to_s

      raise '[remember_params] must specify one or more params to remember' if
        params.empty?
      raise '[remember_params] param name remembered_at is reserved' if
        params.include? :remembered_at
      raise '[remember_params] \'for\' must be ActiveSupport::Duration' unless
        duration.is_a?(ActiveSupport::Duration)
      raise '[remember_params] \'for\' must be gte 1 second' unless
        duration >= 1.second

      cattr_accessor :remember_params_config
      self.remember_params_config ||= {}
      self.remember_params_config[on] = {}
      self.remember_params_config[on][:params] = params
      self.remember_params_config[on][:duration] = duration
      self.remember_params_config[on][:xhr] = xhr

      self.before_action :restore_or_save_params
    end
  end

  def restore_or_save_params
    return unless request.get?
    return unless respond_to? :remember_params_config
    return unless config = self.remember_params_config[action_name]
    return if request.xhr? && !config[:xhr]

    params_to_remember = params
      .permit!
      .slice(*config[:params])
      .to_h
      .delete_if { |k,v| v.to_s.length > 50 }

    key = params.permit(:controller, :action).values.join('/').parameterize
    session[:remembered_params]      ||= {}
    session[:remembered_params][key] ||= {}

    # Reset params
    if
      params[:reset_params].present? ||
      (
        (remembered_at = session[:remembered_params][key]['remembered_at']) &&
        DateTime.parse(remembered_at) < (DateTime.now - config[:duration])
      )
    then
      session[:remembered_params][key] = {}
    end

    # Save params (also refreshes remembered_at after restore)
    if params_to_remember.any?
      session[:remembered_params][key]
        .merge!(params_to_remember.merge(remembered_at: DateTime.now)).compact!
    end

    # Redirect to clean url after reset unless any new params set simultaneously
    if params[:reset_params] && params_to_remember.empty?
      redirect_to {} and return
    end

    # Redirect and restore remembered params unless all present at current location
    if session[:remembered_params][key].except('remembered_at').select{|k,v| params[k] != v}.any?
      redirect_to params: params_to_remember
        .merge(session[:remembered_params][key].except('remembered_at'))
    end
  end
end

ActionController::Base.send :include, RememberParams
