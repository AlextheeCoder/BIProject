library(plumber)

api <- plumber::plumb("plumber_api.R")

api$run(host = "127.0.0.1", port = 5022)
