# noinspection RubyResolve
class StreamPostDecorator < BaseDecorator
  delegate_all
  include ActionView::Helpers::DateHelper

  def to_twitarr_hash(username = nil, options = {})
    length_limit = options[:length_limit] || text.length
    adjusted_text = (text)[0...length_limit]

    result = {
        id: as_str(id),
        author: author,
        timestamp: timestamp,
        display_name: User.display_name_from_username(author),
        text: twitarr_auto_linker(twitarr_replace_emoji(clean_text_with_cr(text))),
        likes: some_likes(username, likes),
        reactions: reaction_summary(reactions),
        parent_chain: parent_chain
    }
    unless photo.blank?
      result[:photo] = { id: photo, animated: PhotoMetadata.find(photo).animated }
    end
    if options.has_key? :remove
      options[:remove].each { |k| result.delete k }
    end
    result
  end

  def to_hash(username = nil, options = {})
    length_limit = options[:length_limit] || text.length
    adjusted_text = (text)[0...length_limit]

    result = {
        id: as_str(id),
        author: author,
        display_name: User.display_name_from_username(author),
        author_last_photo_updated: User.last_photo_updated_from_username(author),
        text: twitarr_auto_linker(replace_emoji(clean_text_with_cr(adjusted_text), options), options),
        timestamp: timestamp,
        display_timestamp: "#{time_ago_in_words(timestamp)} ago",
        likes: some_likes(username, likes),
        all_likes: all_likes(username, likes),
        reactions: reaction_summary(reactions),
        mentions: mentions,
        entities: entities,
        hash_tags: hash_tags,
        location: location,
        parent_chain: parent_chain
    }
    unless photo.blank?
      result[:photo] = { id: photo, animated: PhotoMetadata.find(photo).animated }
    end
    if options.has_key? :remove
      options[:remove].each { |k| result.delete k }
    end
    if options.has_key? :length_limit
      result[:text] << "<br><a href=\"/#/stream/tweet/#{as_str(id)}\">Read More</a>" if text.length > options[:length_limit]
    end
    result
  end

  def to_base_hash
    result = {
        id: as_str(id),
        text: clean_text(text),
    }
    unless photo.blank?
      result[:photo_id] = photo
    end
    result
  end
end
