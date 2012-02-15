module ApplicationHelper
  
  def sortable(column, title = nil)
    title ||= column.titleize
    direction = column == sort_column && sort_direction == "asc" ? "desc" : "asc"
    link_to raw("<span>#{title}</span>"), params.merge(:sort => column, :direction => direction, :page => nil)
  end
  
end
