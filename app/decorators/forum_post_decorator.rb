class ForumPostDecorator < BaseDecorator
  delegate_all

  def to_hash(user = nil, last_view = nil, options = {})
    ret = {
        id: id.to_s,
        forum_id: forum.id.to_s,
        author: {
          username: author,
          display_name: User.display_name_from_username(author),
          last_photo_updated: User.last_photo_updated_from_username(author).to_ms
        },
        text: format_text(text, options),
        timestamp: timestamp.to_ms,
        photos: decorate_photos,
        reactions: BaseDecorator.reaction_summary(reactions, user&.username)
    }
    ret[:new] = (timestamp > last_view) unless last_view.nil?
    ret
  end

  def decorate_photos
    return [] unless photos
    photos.map { |x| 
      begin
        { 
          id: x, 
          animated: !x.blank? && PhotoMetadata.find(x).animated
        } 
      rescue Mongoid::Errors::DocumentNotFound
      end
    }.compact
  end
end
