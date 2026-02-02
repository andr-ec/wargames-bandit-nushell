# Level 16 validation
# Test that SSL certificate was generated

export def "main check" [expected_password: string] {
    try {
        if not (path exists script15.pem) {
            return { success: false, message: "SSL certificate (script15.pem) not found" }
        }

        if not (path exists script15.key) {
            return { success: false, message: "SSL private key (script15.key) not found" }
        }

        return { success: true, message: "SSL certificate and key generated successfully" }
    } catch {
        return { success: false, message: $"Error: ($in.message)" }
    }
}
