# Export user and group ID values as variables for Docker and Docker Compose
export USER_ID=$(id -u $USER)
export GROUP_ID=$(id -g $USER)
