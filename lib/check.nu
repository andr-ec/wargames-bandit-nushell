export def "main check password" [
    user: string,
    expected_password: string,
    current_password: string
] -> record {
    if $expected_password == $current_password {
        return { success: true, message: "Password is correct!" }
    } else {
        return { success: false, message: "Password is incorrect. Try again." }
    }
}

export def "main check file exists" [
    file: string
] -> record {
    let exists = ($file | path exists)
    if $exists {
        return { success: true, message: "File exists." }
    } else {
        return { success: false, message: "File does not exist." }
    }
}

export def "main check file content" [
    file: string,
    expected_content: string
] -> record {
    let actual_content = (open $file)
    if $actual_content == $expected_content {
        return { success: true, message: "File content matches." }
    } else {
        return { success: false, message: "File content does not match." }
    }
}

export def "main check file permission" [
    file: string,
    mode: string
] -> record {
    let file_info = (stat -s $file | get mode)
    if $file_info == $mode {
        return { success: true, message: "Permission matches." }
    } else {
        return { success: false, message: "Permission does not match." }
    }
}

export def "main check file owner" [
    file: string,
    owner: string
] -> record {
    let file_info = (stat -s $file | get owner)
    if $file_info == $owner {
        return { success: true, message: "Owner matches." }
    } else {
        return { success: false, message: "Owner does not match." }
    }
}

export def "main check file group" [
    file: string,
    group: string
] -> record {
    let file_info = (stat -s $file | get group)
    if $file_info == $group {
        return { success: true, message: "Group matches." }
    } else {
        return { success: false, message: "Group does not match." }
    }
}
