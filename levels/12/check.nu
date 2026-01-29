# Level 12 validation
# Decompress hexdump to extract password

export def "main check" [expected_password: string] -> record {
    try {
        if not (data.txt | path exists) {
            return { success: false, message: "data.txt not found" }
        }

        # Create temporary directory for extraction
        let temp_dir = (mktemp -d)

        # Copy data.txt to temp directory
        let source_file = $"$temp_dir/data.txt"

        # Convert hexdump back to binary using hexdump -r
        open data.txt | into binary | save -f $source_file

        # Rename to data1.bin
        mv $source_file $temp_dir/data1.bin

        # Rename to data1.bin
        mv $source_file $temp_dir/data1.bin

        # Decompress step by step
        let files = [
            { name: "data1.bin", cmd: "gzip -dc" },
            { name: "data2.bin", cmd: "bzip2 -dc" },
            { name: "data3.bin", cmd: "tar xf - --absolute-names" },
            { name: "data4.bin", cmd: "gzip -dc" },
            { name: "data5.bin", cmd: "tar xf - --absolute-names" },
            { name: "data6.bin", cmd: "bzip2 -dc" },
            { name: "data7.tar", cmd: "tar xf - --absolute-names" },
            { name: "data8.bin", cmd: "gzip -dc" },
            { name: "data8", cmd: "cat" }
        ]

        let current_file = "data1.bin"
        let current_dir = $temp_dir

        for entry in $files {
            let new_file = $"$current_dir/$entry.name"

            if $entry.cmd | str contains "cat" {
                # Final extraction
                let content = (open $current_file)
                if $content | str contains $expected_password {
                    rm -rf $temp_dir
                    return { success: true, message: "Password extracted successfully!" }
                } else {
                    rm -rf $temp_dir
                    return { success: false, message: "Password not found in extracted data" }
                }
            } else {
                # Run compression/decompression command
                bash -c $"cd $current_dir && { $entry.cmd } < $current_file > $new_file"
            }

            $current_file = $new_file
        }

        rm -rf $temp_dir
        return { success: false, message: "Password not found in extracted data" }
    } catch {
        return { success: false, message: $"Error checking file: ($in.message)" }
    }
}
