module NotesHelper
  def allowed_to_make_notes?
    is_owner_of( @experiment ) || is_default_experiment  
  end

  def is_default_experiment
    @experiment.user.login == 'admin' && @experiment.published
  end

end
