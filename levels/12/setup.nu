# Level 12 setup
# Create hexdump of repeatedly compressed file with password

export def "main setup" [] {
    let password = "36q9ajm7RcKJMOvIa6uncG104kNkCBCG"

    # Create data8 with password and compress it
    bash -c "echo '$password' | gzip -c > data8.bin"

    # Apply compression chain (original order from install.sh)
    tar cvf data7.tar --absolute-names data8.bin 1>/dev/null 2>/dev/null
    bzip2 -c data7.tar > data6.bin
    tar cvf data5.bin --absolute-names data6.bin 1>/dev/null 2>/dev/null
    tar cvf data4.bin --absolute-names data5.bin 1>/dev/null 2>/dev/null
    gzip -c data4.bin > data3.bin
    bzip2 -c data3.bin > data2.bin
    gzip -c data2.bin > data1.bin
    hexdump -e '1/1 "%02x" ' data1.bin > data.txt

    # Clean up intermediate files
    rm -f data8 data8.bin data7.tar data6.bin data5.bin data4.bin data3.bin data2.bin data1.bin

    chmod 640 data.txt

    echo $"Created level 12 with password: $password"

    { success: true, message: $"Level 12 setup complete" }
}
