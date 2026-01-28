export def "main password" [
    length: int = 32
] {
    let wordlist = (open data/7_wordlist.txt.gz | gzip --decompress | lines)
    let password = ($wordlist | each { |item| $item | str rand-length $length } | first)
    $password
}
