get_current_branch = function() Sys.getenv("TRAVIS_BRANCH", Sys.getenv("CI_COMMIT_BRANCH"))
get_sha_range = function() Sys.getenv("TRAVIS_COMMIT_RANGE", Sys.getenv("CI_COMMIT_BEFORE_SHA"))
is_tagging_branch = function() {
  !is.na(Sys.getenv("CI_COMMIT_TAG", NA))  ||
    nchar(Sys.getenv("TRAVIS_TAG")) > 0L
}

get_auth_token = function() {
  if (is_gitlab()) {
    token = Sys.getenv("GITLAB_TOKEN", NA) #nolint
    if (is.na(token)) {
      msg_error("GITLAB_TOKEN missing. Required for tagging")
      stop()
    }
  }

  if (is_travis() || is_ga()) {
    token = Sys.getenv("GITHUB_PAT", NA)
    if (is.na(token)) {
      msg_error("GITHUB_PAT missing. Required for tagging")
      stop()
    }
  }
  return(token)
}

#' @importFrom stringr str_detect str_trim str_split
get_env_variable = function(env_variable, default = NULL) {
  if (is_gitlab() || is_travis() || is_ga()) {
    as.numeric(Sys.getenv(env_variable, default))
  } else if (file.exists(".gitlab-ci.yml")) {
     get_gitlab_env_var(env_variable, default)
  } else if (file.exists(".travis.yml")) {
     get_github_env_var(env_variable, default)
  } else if (file.exists(".github/workflows/")) {
    get_ga_env_var(env_variable, default)
  } else {
    0 # Bug? Should be default?
  }
}

#############################################
## Github Action
#############################################

is_ga = function() !is.na(Sys.getenv("CI", NA))

ga_tree_walker = function(ci, env = "RSPM", value = NULL) {
  if (!is.null(value)) return(value)
  n = names(ci)
  for (i in seq_along(n)) {
    if (n[i] == "env" &&  env %in% names(ci[[i]])) {
      return(ci[[i]][[env]])
    } else {
      value = ga_tree_walker(ci = ci[[i]], env = env, value)
    }
  }
  return(value)
}

# There are multiple github action files
# Walk up and down tree. Stop a first success
get_ga_env_var = function(env_variable, default = NULL) {
  yamls = list.files(".github/workflows/", full.names = TRUE)
  for (i in seq_along(yamls)) {
    ci = yaml::read_yaml(yamls[i])
    value = ga_tree_walker(ci, env_variable)
    if (!is.null(value)) return(value)
  }
  return(default)
}

#############################################
## travis
#############################################
is_travis = function() nchar(Sys.getenv("TRAVIS")) != 0

get_travis_env_var = function(env_variable, default = NULL) {
  r = readLines(".travis.yml")
  env = r[str_detect(r, paste0("^(\\W)*-(\\W)*", env_variable))]
  if (length(env) == 0L) {
    allowed = default
  } else {
    env = stringr::str_remove(env, "#(.*)$")
    env = stringr::str_match(env, "=(.*)")[2]
    env = str_split(env, "=")[[1]]
    allowed = as.numeric(str_trim(env))
  }
  return(allowed)
}

#############################################
## GITLAB
#############################################
is_gitlab = function() nchar(Sys.getenv("GITLAB_CI")) != 0

get_gitlab_env_var = function(env_variable, default = NULL) {
  r = readLines(".gitlab-ci.yml")
  env = r[str_detect(r, paste0("^(\\W)*", env_variable))]
  if (length(env) == 0L) {
    allowed = default
  } else {
    env = stringr::str_remove(env, "#(.*)$")
    env = stringr::str_match(env, ":(.*)")[2]
    allowed = as.numeric(str_trim(env))
  }
  return(allowed)
}
