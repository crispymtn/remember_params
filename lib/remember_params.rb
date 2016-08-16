module RememberParams
  extend ActiveSupport::Concern

  included do
    before_action :restore_or_save_params

    def self.remember_params(*params, on: :index, duration: 1.hour)
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

      self.before_action :restore_or_save_params
    end
  end

  def restore_or_save_params
    return if request.xhr?
    return unless request.get?
    return unless respond_to? :remember_params_config
    return unless config = self.remember_params_config[action_name]

    session[:remembered_params] ||= {}
    key = params.slice(:controller, :action).values.join('/').parameterize
    params_to_remember = params.permit(*config[:params]).to_h

    # Restore params
    if params_to_remember.empty? &&
      session[:remembered_params][key]&.except('remembered_at')&.select{|_,v| v.present?}&.any? &&
      DateTime.parse(session[:remembered_params][key]['remembered_at']) >
        (DateTime.now - config[:duration])
    then
      redirect_to params: session[:remembered_params][key].except('remembered_at')
    end

    # Save params (also refreshes remembered_at after restore)
    if params_to_remember.any?
      params_to_remember['remembered_at'] = DateTime.now
      session[:remembered_params][key] = params_to_remember
    end
  end
end

ActionController::Base.send :include, RememberParams
