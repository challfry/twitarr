Twitarr.PostsMineController = Twitarr.BasePostController.extend
  get_data_ajax: ->
    Twitarr.Post.mine()
