cv_data_path <- function() {
  env_path <- Sys.getenv("CV_DATA_FILE", unset = "")
  if (nzchar(env_path)) {
    return(env_path)
  }

  file.path("C:", "Users", "roscc", "Code", "ros-clayton.github.io", "_data", "cv_content.yml")
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
  cat(paste(cv_escape(unlist(data$profiles$consulting$fields)), collapse = "; "), "\n\n")
}

cv_research_fields <- function(data) {
  cat("# Research Fields\n\n")
  cat(paste(cv_escape(unlist(data$profiles$academic$fields)), collapse = "; "), "\n\n")
}

cv_education <- function(data, profile = "academic") {
  cat("# Education\n\n")
  for (item in data$education) {
    if (profile == "academic" && isTRUE(item$consulting_only)) {
      next
    }
    cat(sprintf(
      "\\textbf{%s, %s} \\hfill %s\n\n",
      cv_escape(item$degree),
      cv_escape(item$institution),
      cv_escape(item$date)
    ))
    detail_field <- if (profile == "consulting") "consulting_details" else "academic_details"
    for (detail in item[[detail_field]] %||% list()) {
      cat(sprintf("\\leavevmode\\hspace*{1em}%s\n\n", cv_escape(detail)))
    }
  }
}

cv_consulting_experience <- function() {
  cat("# Experience\n\n")
  cat("\\textbf{Researcher, Resep, Stellenbosch University} \\hfill 2024--present\n\n")
  cat("- Designed and implemented causal inference studies\n")
  cat("- Analysed and cleaned large administrative datasets in R (data.table) and Stata\n")
  cat("- Conducted quantile regression and fixed effects models to study educational outcomes\n\n")
  cat("\\textbf{Researcher, Independent consultant} \\hfill 2023--2024\n\n")
  cat("- Designed and implemented evaluation studies, including an RCT follow-up using administrative datasets\n")
  cat("- Leveraged LLMs to code qualitative data\n\n")
  cat("\\textbf{Educational Technologist: Learning and Analytics, Siyavula Education} \\hfill 2017--2023\n\n")
  cat("- Ran a significant evaluation of the learning product by matching users on the platform to school administrative data\n")
  cat("- Designed and implemented A/B tests to assess new releases\n\n")
  cat("\\textbf{Director of Learning, Numeric} \\hfill 2016--2017\n\n")
  cat("- Designed and taught supplementary coursework for pre-service teachers\n")
  cat("- Conducted in-classroom observations, typically in poorly-resourced schools\n\n")
  cat("\\textbf{Mathematics Teacher (Grades 8--12), Pinelands High School} \\hfill 2012--2014\n\n")
}

cv_academic_research_experience <- function() {
  cat("# Research Experience\n\n")
  cat("\\textbf{Researcher, Resep, Stellenbosch University} \\hfill 2024--present\n\n")
  cat("- Designed and implemented causal inference studies using RD\n")
  cat("- Analysed and cleaned large administrative datasets in R (data.table) and Stata\n")
  cat("- Conducted quantile regression and fixed effects models to study educational outcomes\n\n")
  cat("\\textbf{Researcher, Independent consultant} \\hfill 2023--2024\n\n")
  cat("- Designed and implemented evaluation studies, including an RCT follow-up using administrative datasets\n")
  cat("- Leveraged LLMs to code qualitative data\n\n")
}

cv_titled_list <- function(items, section_title) {
  cat(sprintf("# %s\n\n", section_title))
  if (is.null(items) || length(items) == 0) {
    return(invisible(NULL))
  }
  for (item in items) {
    cat(sprintf("- %s", cv_entry_title(item)))
    if (!is.null(item$detail) && nzchar(item$detail)) {
      cat(sprintf(" (%s)", cv_escape(item$detail)))
    }
    cat("\n\n")
  }
}

cv_selected_outputs <- function(data) {
  cat("# Selected research and evaluation outputs\n\n")
  for (item in data$working_papers) {
    title <- item$short_title %||% item$title
    cat(sprintf("- %s", cv_entry_title(modifyList(item, list(title = title)))))
    if (!is.null(item$status) && nzchar(item$status)) {
      cat(sprintf(" (%s)", cv_escape(item$status)))
    }
    if (!is.null(item$coauthors) && nzchar(item$coauthors)) {
      cat(sprintf(" (%s.)", cv_escape(item$coauthors)))
    }
    cat("\n\n")
  }
}

cv_working_papers <- function(data) {
  cat("# Working Papers\n\n")
  for (item in data$working_papers) {
    title <- item$title
    if (!is.null(item$url) && nzchar(item$url)) {
      cat(sprintf("%s\n\n", cv_href(item$url, title)))
    } else {
      cat(sprintf("%s\n\n", cv_escape(title)))
    }
    if (!is.null(item$coauthors) && nzchar(item$coauthors)) {
      cat(sprintf("(%s)\n\n", cv_escape(item$coauthors)))
    }
    cat(sprintf("%s\n\n", cv_escape(item$status)))
    description <- item$cv_description %||% item$description
    if (!is.null(description) && nzchar(description)) {
      cat(sprintf("%s\n\n", cv_escape(description)))
    }
  }
}

cv_presentations <- function(data, include_policy = FALSE) {
  cat("# Presentations\n\n")
  items <- data$conference_presentations
  if (include_policy) {
    items <- c(items, data$policy_presentations)
  }
  for (item in items) {
    title <- item$title
    if (!is.null(item$url) && nzchar(item$url)) {
      cat(sprintf("%s\n\n", cv_href(item$url, title)))
    } else {
      cat(sprintf("%s\n\n", cv_escape(title)))
    }
    detail <- item$cv_detail %||% item$detail
    cat(sprintf("%s\n\n", cv_escape(detail)))
  }
}

cv_policy_writing <- function(data) {
  cat("# Policy writing\n\n")
  for (item in data$policy_reports) {
    if (!is.null(item$url) && nzchar(item$url)) {
      cat(sprintf("%s\n\n", cv_href(item$url, item$title)))
    } else {
      cat(sprintf("%s\n\n", cv_escape(item$title)))
    }
    cat(sprintf("%s\n\n", cv_escape(item$detail)))
  }
}

cv_teaching_experience <- function() {
  cat("# Teaching Experience\n\n")
  cat("University of Cape Town\n\n")
  cat("\\textbf{Teaching Assistant, Analysis of Household Survey Data (Honours)} \\hfill 2012\n\n")
  cat("\\textbf{Head Tutor, Game Theory} \\hfill 2011\n\n")
  cat("\\textbf{Tutor} \\hfill 2010--2011\n\n")
  cat("- Microeconomics I\n")
  cat("- Game Theory\n")
  cat("- Microeconomics III\n\n")
}

cv_media <- function(data) {
  if (is.null(data$media) || length(data$media) == 0) {
    return(invisible(NULL))
  }
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
  cat("# Technical Skills\n\n")
  cat("R, Stata, Python, LaTeX\n\n")
}

cv_render_consulting <- function() {
  data <- cv_load()
  cv_profile_header(data, "consulting")
  cv_areas(data)
  cv_education(data, "consulting")
  cv_consulting_experience()
  cv_selected_outputs(data)
  cv_presentations(data, include_policy = TRUE)
  cv_titled_list(data$policy_reports, "Policy and public-facing writing")
  cv_media(data)
  cv_skills(data)
}

cv_render_academic <- function() {
  data <- cv_load()
  cv_profile_header(data, "academic")
  cv_research_fields(data)
  cv_education(data, "academic")
  cv_working_papers(data)
  cv_academic_research_experience()
  cv_presentations(data, include_policy = TRUE)
  cv_policy_writing(data)
  cv_teaching_experience()
  cv_skills(data)
}

cv_render <- function(profile = "academic") {
  if (profile == "consulting") {
    cv_render_consulting()
  } else {
    cv_render_academic()
  }
}

`%||%` <- function(x, y) {
  if (is.null(x)) y else x
}
