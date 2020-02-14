ssh_id = Sys.getenv("id_rsa", "")
ssh_id_file <- "~/.ssh/id_rsa"
write_lines(rawToChar(openssl::base64_decode(ssh_id)), ssh_id_file)
fs::file_chmod(ssh_id_file, "0600")
