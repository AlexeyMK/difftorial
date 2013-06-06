Meteor.Router.add(
  '': 'index'
  '/dummy': ->
    Session.set('next', '#')
    Session.set('previous', '#')
    Session.set('message', 'created dummy for geoff')
    Session.set('diff', [{'filename': 'geoff.js', patch: """
      + Development Seed
      +// Github.js 0.8.0
      +// (c) 2013 Michael Aufreiter, Development Seed
      + // Github.js is freely distributable under the MIT license.
      +    // For all details and documentation:
      +       // http://substance.io/michael/github
    """}])
    return 'tutorial'

  '/:owner/:repo/:sha?': (owner, repo, sha) ->
    Session.set("owner", owner)
    Session.set("repo", repo)
    Session.set('commit_count', 'many')

    # find the first commit if necessary
    sha_promise = $.Deferred()
    if sha?
      sha_promise.resolve(sha)
    else
      NextCommiter.first_commit(owner, repo).done (first_commit) ->
        sha_promise.resolve(first_commit.sha)

    sha_promise.done (sha) ->
      console.log "commit in question is #{sha}"
    ###
    for commit, index in commits
      if commit.sha == sha
        Session.set('index', commits.length - index)
        Session.set('next', commits[index-1]?.sha or '')
        Session.set('previous', commits[index+1]?.sha or '')
        Session.set('message', commit.commit.message)
        else
          commit = commits[commits.length - 1]
          sha = commit.sha
          Session.set('index', 1)
          Session.set('next', commits[commits.length - 2].sha)
          Session.set('previous', '')
          Session.set('message', commit.commit.message)

        $.ajax(
          url: "https://api.github.com/repos/#{owner}/#{repo}/commits/#{sha}",
        ).done (result) ->
          diff = ({filename: file.filename, patch: file.patch} for file in result.files)
          Session.set('diff', diff)
          ###
    return 'tutorial'
  '*': '404'
)

NextCommiter =
  first_commit: (owner, repo) ->
    first_commit_promise = $.Deferred()
    $.ajax(
      url: "https://api.github.com/repos/#{owner}/#{repo}"
    ).done (repo_data) ->
      # grab first commit
      # filtering by date to hope to get initial commits only
      $.ajax(
        url: "https://api.github.com/repos/#{owner}/#{repo}/commits"
        data:
          per_page: 100
          sha: 'master'
          until: repo_data.created_at
      ).done (earliest_commits) ->
        first_commit_promise.resolve(earliest_commits.pop())

    return first_commit_promise

  next_commit: () ->
    return "bob"

###
spec for paginated commit giver:
  - INTERFACE:
    - I should be able to say "give me the next commit" and you do
      - and sometimes you do a little bit of work in the background too
###
