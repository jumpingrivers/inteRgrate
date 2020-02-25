ssh_id = Sys.getenv("id_rsa1", NA)
if (is.na(ssh_id)) stop("NO RSA")
ssh_id_file <- "~/.ssh/id_rsa"
readr::write_lines(rawToChar(openssl::base64_decode(ssh_id)), ssh_id_file)
fs::file_chmod(ssh_id_file, "0600")
