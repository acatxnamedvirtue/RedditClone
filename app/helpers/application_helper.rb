module ApplicationHelper
  def form_auth_token
    <<-HTML.html_safe
    <input type="hidden"
           name="authenticity_token"
           value="#{form_authenticity_token}">
    HTML
  end

  def all_subs
    Sub.all
  end

  def score(votable)
    votable.votes.inject(0) { |sum, vote| sum + vote.value}
  end
end
