Twitarr.Router.map ()->
  @resource 'seamail', ->
    @route 'detail', { path: ':id' }
    @route 'new'

  @resource 'forums', ->
    @route 'page', { path: ':page' }
    @route 'new_post', { path: ':id/new' }
    @route 'detail', { path: 'thread/:id/:page'}
    @route 'edit', { path: 'thread/:forum_id/edit/:post_id'}
    @route 'new'

  @resource 'stream', ->
    @route 'page', { path: ':page' }
    @route 'star_page', { path: 'star/:page' }
    @route 'new'
    @route 'edit', { path: 'edit/:id'}
    @route 'view', { path: 'tweet/:id' }
    @route 'mentions', { path: 'mentions/:username'}
    @route 'mentions_page', { path: 'mentions/:username/:page'}
    @route 'author', { path: 'author/:username'}
    @route 'author_page', { path: 'author/:username/:page'}

  @resource 'search', ->
    @route 'results', { path: ':text' }
    @route 'user_results', { path: 'user/:text' }
    @route 'tweet_results', { path: 'tweet/:text' }
    @route 'forum_results', { path: 'forum/:text' }
    @route 'event_results', { path: 'event/:text' }

  @resource 'admin', ->
    @route 'announcements'
    @route 'announcements_edit', { path: 'announcements/:id' }
    @route 'upload_schedule'
    @route 'search', { path: 'users' }
    @route 'users', { path: 'users/:text' }
    @route 'profile', { path: 'users/:username/profile' }
    @route 'sections', { path: 'sections' }

  @resource 'schedule', ->
    @route 'today', { path: 'today' }
    @route 'day', { path: 'day/:date' }
    @route 'new', { path: 'new'}
    @route 'detail', { path: 'event/:id' }
    @route 'edit', { path: 'event/:id/edit'}
    @route 'upload', {path: 'upload'}

  @resource 'events', ->
    @route 'today', { path: 'today' }
    @route 'day', { path: 'day/:date' }

  @resource 'user', ->
    @route 'profile', { path: 'profile/:username' }
    @route 'new', { path: 'new' }
    @route 'login', { path: 'login' }
    @route 'forgot_password', { path: 'forgot_password' }

  @route 'tag', { path: 'tag/:tag_name', model: Twitarr.UserNew }
  @route 'alerts'
  @route 'starred'
  @route 'time'
  @route 'help'
  @route 'conduct'
  