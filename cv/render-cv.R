cv_data_path <- function() {
  env_path <- Sys.getenv("CV_DATA_FILE", unset = "")
  if (nzchar(env_path)) {
    return(env_path)
  }

  file.path("C:", "Users", "roscc", "Code", "ros-clayton.github.io", "cv", "cv-data.yml")
}

cv_load <- function(path = cv_data_path()) {
  if (!requireNamespace("yaml", quietly = TRUE)) {
    stop("The yaml R package is required to render the CV.")
  }
  yaml::read_yaml(path)
}

cv_escape <- function(x) {
  if (is.null(x) || length(x) == 0) {
    return("")
  }
  x <- as.character(x)
  replacements <- c(
    "\\" = "\\textbackslash{}",
    "&" = "\\&",
    "%" = "\\%",
    "$" = "\\$",
    "#" = "\\#",
    "_" = "\\_",
    "{" = "\\{",
    "}" = "\\}",
    "~" = "\\textasciitilde{}",
    "^" = "\\textasciicircum{}"
  )
  for (pattern in names(replacements)) {
    x <- gsub(pattern, replacements[[pattern]], x, fixed = TRUE)
  }
  x
}

cv_href <- function(url, label) {
  sprintf("\\href{%s}{%s}", url, cv_escape(label))
}

cv_bold <- function(x) {
  sprintf("\\textbf{%s}", x)
}

cv_entry_title <- function(item) {
  title <- cv_escape(item$title)
  if (!is.null(item$url) && nzchar(item$url)) {
    title <- cv_href(item$url, item$title)
  }
  cv_bold(title)
}

cv_profile_header <- function(data, profile = "academic") {
  prof <- data$profiles[[profile]]
  if (is.null(prof)) {
    stop("Unknown CV profile: ", profile)
  }

  lines <- c(
    "\\begin{center}",
    sprintf("{\\LARGE \\textbf{%s}}\\\\", cv_escape(prof$name)),
    paste0(cv_escape(unlist(prof$label)), "\\\\"),
    sprintf("\\href{mailto:%s}{%s}", prof$email, cv_escape(prof$email)),
    "\\end{center}"
  )
  cat(paste(lines, collapse = "\n"), "\n\n")
}

cv_areas <- function(data) {
  cat("# Areas of expertise\n\n")
  cat(paste(cv_escape(unlist(data$areas)), collapse = "; "), "\n\n")
}

cv_education <- function(data) {
  cat("# Education\n\n")
  for (item in data$education) {
    cat(sprintf(
      "\\textbf{%s, %s} \\hfill %s\n\n",
      cv_escape(item$degree),
      cv_escape(item$institution),
      cv_escape(item$date)
    ))
    for (detail in item$details %||% list()) {
      cat(sprintf("\\leavevmode\\hspace*{1em}%s\n\n", cv_escape(detail)))
    }
  }
}

cv_experience <- function(data) {
  cat("# Experience\n\n")
  for (item in data$experience) {
    cat(sprintf(
      "\\textbf{%s, %s} \\hfill %s\n\n",
      cv_escape(item$role),
      cv_escape(item$organisation),
      cv_escape(item$date)
    ))
    bullets <- item$bullets %||% list()
    if (length(bullets) > 0) {
      for (bullet in bullets) {
        cat(sprintf("- %s\n", cv_escape(bullet)))
      }
      cat("\n")
    }
  }
}

cv_titled_list <- function(items, section_title) {
  cat(sprintf("# %s\n\n", section_title))
  for (item in items) {
    cat(sprintf("- %s", cv_entry_title(item)))
    if (!is.null(item$detail) && nzchar(item$detail)) {
      cat(sprintf(" (%s)", cv_escape(item$detail)))
    }
    cat("\n\n")
  }
}

cv_media <- function(data) {
  cat("# Research impact and media\n\n")
  for (item in data$media) {
    text <- cv_escape(item$text)
    if (!is.null(item$url) && nzchar(item$url)) {
      text <- cv_href(item$url, item$text)
    }
    cat(sprintf("- %s\n", text))
  }
  cat("\n")
}

cv_skills <- function(data) {
  cat("# Technical skills\n\n")
  cat(paste(cv_escape(unlist(data$skills)), collapse = ", "), "\n\n")
}

cv_render <- function(profile = "academic") {
  data <- cv_load()
  cv_profile_header(data, profile)
  cv_areas(data)
  cv_education(data)
  cv_experience(data)
  cv_titled_list(data$outputs, "Selected research and evaluation outputs")
  cv_titled_list(data$presentations, "Presentations")
  cv_titled_list(data$policy_writing, "Policy and public-facing writing")
  cv_media(data)
  cv_skills(data)
}

`%||%` <- function(x, y) {
  if (is.null(x)) y else x
}
