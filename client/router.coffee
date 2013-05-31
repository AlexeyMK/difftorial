Meteor.Router.add(
  '/': 'hello'
  '/tutorial/:owner/:repo/:sha': (owner, repo, sha) ->
    base = ""
    $.ajax
      url: "https://api.github.com/repos/#{owner}/#{repo}/commits"
      success: (commits) ->
        # AMK HERE set up dependencies
        parent_to_child = {}
        child_to_parent = {}
        for commit in commits
          parent_to_child[commit.parents[0].sha] = commit.sha
          child_to_parent[commit.sha] = commit.parents[0].sha

        Session.set('next', parent_to_child[commit.sha])
        Session.set('previous', child_to_parent[commit.sha])
        base = child_to_parent[commit.sha]
        $.ajax
          url: "https://api.github.com/repos/#{owner}/#{repo}/compare/#{base}...#{sha}",
          success: (result) ->
            diff = ({filename: file.filename, patch: file.patch} for file in result.files)
            Session.set('diff', diff)
  '*': '404'
)
