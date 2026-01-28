export def "main create user" [
    username: string,
    password: string,
    home_dir: string,
    shell: string,
    sudo: bool = false
] {
    # Create user
    sudo useradd --create-home --shell $shell --home-dir $home_dir $username

    # Set password
    echo $password | sudo chpasswd --stdin $username

    if $sudo {
        sudo usermod -aG sudo $username
    }

    # Create password file with correct permissions
    $home_dir | path join "bandit_pass" | sudo mkdir -p
    echo $password | sudo tee -a ($home_dir | path join "bandit_pass" | path join $username) > /dev/null
    sudo chown $username:bandit ($home_dir | path join "bandit_pass" | path join $username)
    sudo chmod 640 ($home_dir | path join "bandit_pass" | path join $username)
}

export def "main set perms" [
    file: string,
    owner: string,
    group: string,
    mode: string
] {
    sudo chown $owner:$group $file
    sudo chmod $mode $file
}

export def create-readme [
    file_path: string,
    content: string
] {
    echo $"Creating file: ($file_path)"
    mkdir -p (path dirname $file_path)
    echo ($content) | save -f ($file_path)
    echo $"File created: ($file_path)"
}

export def create-hidden-file [
    file_path: string,
    content: string
] {
    echo $"Creating hidden file: ($file_path)"
    mkdir -p (path dirname $file_path)
    echo ($content) | save -f $"($file_path).($file_path)"
}

export def create-file-with-size [
    file_path: string,
    size_bytes: int,
    content: string = "X"
] {
    echo $"Creating file of size ($size_bytes) bytes: ($file_path)"
    mkdir -p (path dirname $file_path)
    (content | str repeat $size_bytes) | save -f ($file_path)
}

export def create-folder [
    folder_path: string
] {
    echo $"Creating folder: ($folder_path)"
    mkdir -p ($folder_path)
    echo $"Folder created: ($folder_path)"
}
