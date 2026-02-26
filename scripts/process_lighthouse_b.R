source("scripts/get_token.R")
source("scripts/get_old_bookings.R")


# get_token ----
token <- get_token(client_secret = client_secret)

# Her skal vi nok have noget ind, der sikrer at jeg har directories at 
# arbejde med lokalt.

repo_b_dir <- Sys.getenv("REPO_B_DIR", unset = NA_character_)
if (is.na(repo_b_dir) || repo_b_dir == "") {
  stop("REPO_B_DIR is not set")
}

# Eksempel: fil i lighthouse-B
input_path <- file.path(repo_b_dir, "data", "input.csv")
bookings_path <- file.path(repo_b_dir, "data", "bookings.csv")
bookings_details_path <- file.path(repo_b_dir, "data", "bookings_details.csv")

library(readr)
library(dplyr)

print(input_path)
print(bookings_path)
print(bookings_details_path)

# Behandler input_path - som ikke er så relevant for noget, men 
# som vi beholder som eksempel på noget der virker.
if(!file.exists(input_path)) {
  stop("File not found: ", input_path) # her skal vi ikke stoppe - vi skal generere den første fil
}else{
  df <- readr::read_csv(input_path, show_col_types = FALSE)
  # ---- DINE TRANSFORMATIONER ----
  df <- df |> dplyr::mutate(processed_at = Sys.time())

  # Skriv direkte tilbage til lighthouse-B
  readr::write_csv(df, input_path)
}

# lille forsøg med bookings_path
if(!file.exists(bookings_path)){
  bookings <- get_old_bookings(token)
  readr::write_csv(bookings, bookings_path)
}else{
  bookings <- readr::read_csv(bookingss_path, show_col_types = FALSE)
  bookings <- bookings |> dplyr::mutate(processed_at = Sys.time())
  readr::write_csv(bookings, bookings_path)
}

# Her behandler vi de rå bookingsdata
# if (!file.exists(bookings_path)) {
#   bookings <- get_old_bookings(token)  # henter bookings tre år tilbage
#   readr::write_csv(bookings, bookings_path) # skriver dem til repo-B
#   # stop("File not found: ", bookings_path) # her skal vi ikke stoppe - vi skal generere den første fil
# }else{
#   bookings <- readr::read_csv(bookings_path, show_col_types = FALSE)
#   # ---- DINE TRANSFORMATIONER ----
#   bookings <- bookings |> dplyr::mutate(processed_at = Sys.time())

#   # Skriv direkte tilbage til lighthouse-B
#   readr::write_csv(bookings, bookings_path)
# }

# # Her behandler vi detaljer for bookings
# if (!file.exists(bookings_details_path)) {
#   stop("File not found: ", bookings_details_path) # her skal vi ikke stoppe - vi skal generere den første fil
# }else{
#   booking_details <- readr::read_csv(bookings_details_path, show_col_types = FALSE)
#   # ---- DINE TRANSFORMATIONER ----
#   booking_details <- booking_details |> dplyr::mutate(processed_at = Sys.time())

#   # Skriv direkte tilbage til lighthouse-B
#   readr::write_csv(booking_details, bookings_details_path)
# }

