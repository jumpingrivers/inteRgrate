get_current_branch = function() Sys.getenv("TRAVIS_BRANCH", Sys.getenv("CI_COMMIT_BRANCH"))
get_sha_range = function() Sys.getenv("TRAVIS_COMMIT_RANGE", Sys.getenv("CI_COMMIT_BEFORE_SHA"))
is_tagging_branch = function() {
  message("chars ", nchar(Sys.getenv("TRAVIS_TAG")))
  message("chars ", Sys.getenv("TRAVIS_TAG", NA))

  !is.na(Sys.getenv("CI_COMMIT_TAG", NA))  ||
    nchar(Sys.getenv("TRAVIS_TAG")) > 0L
}

get_auth_token = function() {
  if (is_gitlab()) {
    token = Sys.getenv("GITLAB_TOKEN", NA) #nolint
    if (is.na(token)) {
      msg_error("GITLAB_TOKEN missing. Required for tagging", stop = TRUE)
    }
  }

  if (is_github()) {
    token = Sys.getenv("GITHUB_PAT", NA)
    if (is.na(token)) {
      msg_error("GITHUB_PAT missing. Required for tagging", stop = TRUE)
    }
  }
  return(token)
}


#' @importFrom stringr str_detect str_trim str_split
get_env_variable = function(env_variable, default = NULL) {
  if (is_gitlab() || is_github()) {
    var = as.numeric(Sys.getenv(env_variable, default))
  } else if (file.exists(".gitlab-ci.yml")) {
    var = get_gitlab_env_var(env_variable, default)
  } else if (file.exists(".travis.yml")) {
    var = get_github_env_var(env_variable, default)
  } else {
    var = 0
  }
  return(var)
}

#############################################
## GITHUB
#############################################
is_github = function() nchar(Sys.getenv("TRAVIS")) != 0

get_github_env_var = function(env_variable, default = NULL) {
  r = readLines(".travis.yml")
  env = r[str_detect(r, env_variable)]
  if (length(env) == 0L) {
    allowed = default
  } else {
    env = str_split(env, "=")[[1]]
    allowed = as.numeric(str_trim(env)[2])
  }
  return(allowed)
}

#############################################
## GITLAB
#############################################
is_gitlab = function() nchar(Sys.getenv("GITLAB_CI")) != 0

get_gitlab_env_var = function(env_variable, default = NULL) {
  r = readLines(".gitlab-ci.yml")
  env = r[str_detect(r, env_variable)]
  if (length(env) == 0L) {
    allowed = default
  } else {
    env = str_split(env, ":")[[1]]
    allowed = as.numeric(str_trim(env)[2])
  }
  return(allowed)
}

##############################################
## Build dir
#############################################
get_build_dir = function(path = NULL) {
  if (is.null(path)) {
    if (is_github()) {
      path = Sys.getenv("TRAVIS_BUILD_DIR", getwd())
    } else if (is_gitlab()) {
      path = Sys.getenv("CI_PROJECT_DIR", getwd())
    } else {
      path = getwd()
    }
  }
  return(path)
}
