export def validate-password [
    password: string,
    expected_password: string
] {
    if $password == $expected_password {
        {
            success: true,
            message: "Password validated successfully"
        }
    } else {
        {
            success: false,
            message: $"Password mismatch. Expected: ($expected_password), Got: ($password)"
        }
    }
}

export def validate-file-exists [
    file_path: string,
    required: bool = true
] {
    if $required {
        if path exists $file_path {
            {
                success: true,
                message: $"File exists: ($file_path)"
            }
        } else {
            {
                success: false,
                message: $"File not found: ($file_path)"
            }
        }
    } else {
        if not (path exists $file_path) {
            {
                success: true,
                message: $"File does not exist as expected: ($file_path)"
            }
        } else {
            {
                success: false,
                message: $"File should not exist but does: ($file_path)"
            }
        }
    }
}

export def validate-file-content [
    file_path: string,
    expected_content: string,
    exact: bool = false
] {
    try {
        let actual_content = open ($file_path) | str trim
        if $exact {
            if $actual_content == $expected_content {
                {
                    success: true,
                    message: $"Content matches exactly"
                }
            } else {
                {
                    success: false,
                    message: $"Content mismatch. Expected: ($expected_content), Got: ($actual_content)"
                }
            }
        } else {
            if $actual_content | str downcase | str contains ($expected_content | str downcase) {
                {
                    success: true,
                    message: $"Content contains expected text"
                }
            } else {
                {
                    success: false,
                    message: $"Content does not contain expected text"
                }
            }
        }
    } catch {
        {
            success: false,
            message: $"Error reading file: ($file_path)"
        }
    }
}

export def validate-password-file [
    file_path: string,
    owner: string,
    group: string,
    mode: string = "640"
] {
    let file_exists = validate-file-exists $file_path true

    if not $file_exists.success {
        return $file_exists
    }

    try {
        let permissions = ls -l $file_path | get permissions | split row ' ' | get 0

        if $permissions != $mode {
            return {
                success: false,
                message: $"Wrong permissions: ($permissions), expected: ($mode)"
            }
        }

        {
            success: true,
            message: $"Password file valid"
        }
    } catch {
        {
            success: false,
            message: $"Error checking file permissions"
        }
    }
}

export def validate-hidden-file [
    file_path: string,
    content: string?
] {
    let actual_path = $"($file_path).($file_path)"

    if $content != null {
        let content_check = validate-file-content $actual_path $content
        if not $content_check.success {
            return $content_check
        }
    }

    if not (path exists $actual_path) {
        return {
            success: false,
            message: $"Hidden file not found: ($actual_path)"
        }
    }

    {
        success: true,
        message: $"Hidden file exists: ($actual_path)"
    }
}
