# Level 7 setup
# Find password next to word "millionth" in data.txt

export def "main setup" [] {
    let password = "9JkI8LZJPUprjaHEQKKnN1LLYtCLKCid"

    # Copy wordlist from data directory
    cp data/7_wordlist.txt.gz data.txt.gz
    gzip -d data.txt.gz

    # Find the line containing "millionth"
    let line = (grep "millionth" data.txt | get 0)

    # Replace "millionth" with "millionth\t<password>"
    let replacement = ($line | str replace "millionth" "millionth\t" + $password)
    $replacement | save -f data.txt -a

    chmod 640 data.txt

    echo $"Created level 7 with password: $password"

    { success: true, message: $"Level 7 setup complete" }
}
