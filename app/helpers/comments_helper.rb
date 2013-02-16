module CommentsHelper
  def find_peoper_class(comment)
    if can? :update, comment
      'btn-group btn-group-vertical'
    end
  end

  def hide_comment?(comment)
    if comment.total_point < Comment::HIDE_THRESHOLD
      return true
    end
    return false
  end
end
