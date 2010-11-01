module EncyclopaediasHelper
  def create_menu_links(title)
    link = "<a href = \"##{title}\">#{title}</a>"
    return link
  end
  def create_section_edit_link(href, link_text)
     link = "<a href = \"##{href}\">#{link_text}</a>"
    return link
  end
  def create_bookmark(title)
    bookmark = "<a class=section_title name=\"#{title}\">#{title}</a> "
    return bookmark
  end
  def create_em(term)
      definition = "<em class = \"#{term.term}\">#{term.definition}</em>"
      return definition
  end
  def create_div_class(title)
      div = "<div class=\"##{title.title}\">"
      return div
  end

   def last_div()
      return "</div>"
  end
end
