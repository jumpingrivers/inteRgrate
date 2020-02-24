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
    env = str_match(env, ":(.*)?#")[1, 2]
    allowed = as.numeric(str_trim(env))
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
