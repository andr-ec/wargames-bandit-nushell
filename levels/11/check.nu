# Level 11 validation
# Decode ROT13 to find password

export def "main check" [expected_password: string] -> record {
    if not ("data.txt" | path exists) {
        return { success: false, message: "data.txt not found" }
    }

    # Read the file and decode ROT13 using tr
    let encoded = (open data.txt | str trim)
    let decoded = ($encoded | ^tr 'a-mn-zA-MN-Z' 'n-za-mN-ZA-M')

    # Check if password is in decoded content
    if ($decoded | str contains $expected_password) {
        return { success: true, message: "Password found after ROT13 decoding!" }
    }

    { success: false, message: "Password not found in decoded data" }
}
