module NotesHelper
  def allowed_to_make_notes?
    is_owner_of( @experiment )  
  end
end
