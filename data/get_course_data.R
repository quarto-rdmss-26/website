# header ------------------------------------------------------------------

# This script accesses the tables stored as Google Sheets which contain
# the course data. Each table is read and stored locally as a CSV.

# library -------------------------------------------------------------------

library(googlesheets4)
library(readr)
library(dplyr)
library(lubridate)
library(stringr)

# script ------------------------------------------------------------------

# course-schedule

link_lesson_plan <- "https://docs.google.com/spreadsheets/d/1b2osej0p-3rg12_uPwjlWC5mAXmbVX_jnipqdHnY7CQ/edit?gid=0#gid=0"

googlesheets4::read_sheet(link_lesson_plan) |>
  mutate(title = case_when(
    is.na(page_link) == FALSE ~  paste0("[", title, "](", page_link, "/)"),
    TRUE ~ title
  )) |>
  mutate(start_time = as.character(start_time)) |>
  mutate(start_time = str_extract(start_time, "\\b\\d{2}:\\d{2}\\b")) |>
  mutate(end_time = as.character(end_time)) |>
  mutate(end_time = str_extract(end_time, "\\b\\d{2}:\\d{2}\\b")) |>
  mutate(time = paste(start_time, end_time, sep = " - ")) |>
  write_csv(here::here("data/tbl-01-quarto-rdmss-26-course-schedule.csv"))
