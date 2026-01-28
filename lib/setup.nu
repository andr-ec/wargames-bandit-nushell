export def create-user [
    username: string,
    password: string,
    home_dir: string = "/home/bandit",
    shell: string = "/bin/bash"
] {
    let home_path = $"($home_dir)/($username)"

    echo $"Creating user: ($username)"
    useradd -m -s ($shell) ($username)
    echo $"Updating password for: ($username)"
    echo ($password) | chpasswd -u ($username)
    echo $"Home directory: ($home_path)"
    echo $"User created successfully"
}

export def create-group [group_name: string] {
    echo $"Creating group: ($group_name)"
    groupadd ($group_name)
}

export def set-permissions [
    file_path: string,
    owner: string,
    group: string,
    mode: string = "640"
] {
    echo $"Setting permissions for: ($file_path)"
    chmod ($mode) ($file_path)
    chown ($owner):($group) ($file_path)
    echo $"Permissions set: mode=($mode), owner=($owner), group=($group)"
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
