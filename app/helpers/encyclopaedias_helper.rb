module EncyclopaediasHelper
  def create_menu_links(title)
    link = "<a href = \"##{title}\">#{title}</a>"
    return link
  end
  def create_bookmark(title)
    bookmark = "<a name=\"#{title}\">#{title}</a> "
    return bookmark
  end
  def create_em(term)
      definition = "<em class = \"#{term.term}\">#{term.definition}</em>"
      return definition
  end
end
