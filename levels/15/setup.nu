# Level 15 setup
# Setup TCP listener on port 30000

export def "main setup" [] {
    let password = "4wpMlaU4S7rYlDo79Ubu6x32QPz7dnt2"

    # Copy the TCP listener script
    cp ../scripts/14_listener_tcp.py script14.py

    # Run the listener in background
    bash -c "python3 ../scripts/14_listener_tcp.py &"

    # Wait a moment for listener to start
    sleep 2

    echo $"Created level 15 with password: $password"

    { success: true, message: $"Level 15 setup complete" }
}
