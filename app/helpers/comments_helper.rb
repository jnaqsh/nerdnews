module CommentsHelper
  def find_peoper_class(comment)
    if can? :update, comment
      'btn-group btn-group-vertical'
    end
  end
end
