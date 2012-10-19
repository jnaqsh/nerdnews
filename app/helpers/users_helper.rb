module UsersHelper
  def render_correct_partial
    if params[:render] == 'comments'
      render partial: 'user_comments', object: @comments || t('.no_comment')
    elsif params[:render] == 'favorites'
      render partial: 'user_favorites', object: @favorites || t('.no_article')
    else
      render partial: 'user_story', object: @stories || t('.no_article')
    end
  end
end
