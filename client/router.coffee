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
    # AMK TODO next:
    # figure out which commit we are on, probably by recursing

    # find the first commit if necessary
    sha_promise = $.Deferred()
    if sha?
      sha_promise.resolve(sha)
    else
      NextCommiter.first_commit(owner, repo).done (first_commit) ->
        sha_promise.resolve(first_commit.sha)

    next_sha_promise = $.Deferred()
    sha_promise.done (sha) ->
      NextCommiter.next_commit(owner, repo, sha).done(next_sha_promise.resolve)

    next_sha_promise.done (next_sha) ->
      Session.set('next', next_sha)

    sha_promise.done (sha) ->
      $.ajax(
        url: "https://api.github.com/repos/#{owner}/#{repo}/commits/#{sha}",
      ).done (result) ->
        Session.set('message', result.commit.message)

        if result.parents.length > 0
          Session.set('previous', result.parents[0].sha)

        diff = ({filename: file.filename, patch: file.patch} \
          for file in result.files)
        Session.set('diff', diff)
    return 'tutorial'
  '*': '404'
)

NextCommiter =
  first_commit: (owner, repo) ->
    first_commit_promise = $.Deferred()
    $.ajax(
      url: "https://api.github.com/repos/#{owner}/#{repo}"
    ).done (repo_data) ->
      console.log repo_data
      # grab first commit
      # filtering by date to hope to get initial commits only
      $.ajax(
        url: "https://api.github.com/repos/#{owner}/#{repo}/commits"
        data:
          per_page: 100
          sha: 'master'
          until: repo_data.created_at
      ).done (earliest_commits) ->
        # AMK TODO NEXT:
        # try /yefim/dbide:
        #   we run into the  'earliest_commits is empty' problem
        first_commit_promise.resolve(earliest_commits.pop())

    return first_commit_promise

  next_commit: (owner, repo, current_sha) ->
    # TODO this is where all the really clever caching stuff eventually comes
    # for now: paginate through commits until you find a child of this commit
    next_commit_promise = $.Deferred()

    pore_through_github_commits = (owner, repo, url) ->
      ajax_args = if url? then {url} else {
        url: "https://api.github.com/repos/#{owner}/#{repo}/commits"
        data:
          per_page: 100
          sha: 'master'
      }

      commit_query = $.ajax(ajax_args).done (commits) ->
        for commit in commits
          for parent in commit.parents
            if parent.sha is current_sha
              next_commit_promise.resolve(commit.sha)

        unless next_commit_promise.state() is 'resolved'
          console.log "going deeper"
          # TODO case for 'we totally didn't find it.'
          # could not find, must go deeper - follow github's `next` link
          next_url = commit_query.getResponseHeader('link')?.split(" ")[0]
          if next_url
            next_url = next_url[1..next_url.length - 3]
            pore_through_github_commits owner, repo, next_url

    pore_through_github_commits(owner, repo)

    return next_commit_promise

###
spec for paginated commit giver:
  - INTERFACE:
    - I should be able to say "give me the next commit" and you do
      - and sometimes you do a little bit of work in the background too
###
