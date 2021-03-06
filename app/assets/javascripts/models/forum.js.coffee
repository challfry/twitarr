Twitarr.ForumMeta = Ember.Object.extend
  id: null
  subject: null
  posts: null
  timestamp: null

Twitarr.ForumMeta.reopenClass
  page: (page, participated = false) ->
    $.getJSON("#{Twitarr.api_path}/forums?page=#{page}&participated=#{participated}").fail((response)=>
      if response.responseJSON?.error?
        alert(response.responseJSON.error)
      else
        alert('Something went wrong. Please try again later.')
    ).then((data) =>
      { forums: Ember.A(@create(meta)) for meta in data.forum_threads, next_page: data.next_page, prev_page: data.prev_page, page: data.page, page_count: data.page_count }
    )

Twitarr.Forum = Ember.Object.extend
  id: null
  subject: null
  posts: []
  timestamp: null
  as_mod: false,
  as_admin: false

  objectize: (->
    @set('posts', Ember.A(Twitarr.ForumPost.create(post)) for post in @get('posts'))
  ).on('init')

Twitarr.Forum.reopenClass
  get: (id, page = 0) ->
    $.getJSON("#{Twitarr.api_path}/forums/#{id}?page=#{page}").then (data) =>
      { forum: @create(data.forum_thread), next_page: data.forum_thread.next_page, prev_page: data.forum_thread.prev_page, page: data.forum_thread.page, page_count: data.forum_thread.page_count }

  new_post: (forum_id, text, photos, as_mod, as_admin) ->
    $.post("#{Twitarr.api_path}/forums/#{forum_id}", { text: text, photos: photos, as_mod: as_mod, as_admin: as_admin }).then (data) =>
      data.forum_post = Twitarr.ForumPost.create(data.forum_post) if data.forum_post?
      data

  new_forum: (subject, text, photos, as_mod, as_admin) ->
    $.post("#{Twitarr.api_path}/forums", { subject: subject, text: text, photos: photos, as_mod: as_mod, as_admin: as_admin }).then (data) =>
      { forum: @create(data.forum_thread), next_page: null, prev_page: null }

Twitarr.ForumPost = Ember.Object.extend
  photos: []
  reactions: []

  objectize: (->
    @set('photos', Ember.A(Twitarr.Photo.create(photo) for photo in @get('photos')))
  ).on('init')

  user_likes: (->
    @get('reactions') && @get('reactions')['like'] && @get('reactions')['like'].me
  ).property('reactions')

  likes_string: (->
    reactions = @get('reactions')
    return '' unless reactions

    likes = reactions['like']
    return '' unless likes
    
    if likes.me
      output = 'You'
      likes.count -= 1
      
      if likes.count > 0
        output += " and #{likes.count} other"
      else
        output += " like this."
        return output
    else
      output = "#{likes.count}"
    
    if likes.count > 1
      output += " seamonkeys like this."
    else
      output += " seamonkey likes this."

    return output
  ).property('reactions')

  react: (word) ->
    $.post("#{Twitarr.api_path}/forums/#{@get('forum_id')}/#{@get('id')}/react/#{word}").then (data) =>
      @set('reactions', data.reactions)

  unreact: (word) ->
    $.ajax("#{Twitarr.api_path}/forums/#{@get('forum_id')}/#{@get('id')}/react/#{word}", method: 'DELETE').then (data) =>
      @set('reactions', data.reactions)
  
  delete: (forum_id, post_id) ->
    $.ajax("#{Twitarr.api_path}/forums/#{forum_id}/#{post_id}", method: 'DELETE')

Twitarr.ForumPost.reopenClass
  get: (forum_id, post_id) ->
    $.getJSON("#{Twitarr.api_path}/forums/#{forum_id}/#{post_id}?app=plain").then (data) =>
      data

  edit: (forum_id, post_id, text, photo_ids) ->
    $.post("#{Twitarr.api_path}/forums/#{forum_id}/#{post_id}", { text: text, photos: photo_ids })
