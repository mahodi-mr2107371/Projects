
### Team Calcium 
-  Mahodi Sabab
- Khalid Mahmoud
- Omar Qutb
- Mohammed Abunada

### Introduction

This phase of the project was mainly about a multi-room chatting  server designed to allow multiple users to communicating  concurrently. This included server ,client side implementations and room management like kick , leave , join . We reached this approach by the help of the synchronization techniques  and multithread handling. 

### Implementation Overview: 

#### Server : 
- The server manages client connections, user data, and chat rooms. It listens on port **13337** and uses multithreading to handle multiple users simultaneously. 
- Tickets are used for user identification, loaded from a file at startup, and saved persistently. 
- Shared resources like users, rooms, and tickets are stored in synchronized maps to ensure thread safety. 

```
Socket clientSocket = serverSocket.accept();
User user = new User(clientSocket);
Thread userThread = new Thread(user);
userThread.start();
```

```
synchronized (pseudonyms) {
    if (pseudonyms.get(pseudonym) == null) {
        pseudonyms.put(pseudonym, user);
    }
}
```

#### Client: 
- The client connects to the server using sockets and allows users to interact with chat rooms and other participants.
- Users are identified via tickets or pseudonyms, which are validated by the server during login.
- The client runs two threads: one for reading server responses and another for sending user inputs.

```

Socket socket = new Socket(host, port);
BufferedReader in = new BufferedReader(new InputStreamReader(socket.getInputStream()));
PrintWriter out = new PrintWriter(socket.getOutputStream(), true);

Thread readThread = new Thread(() -> {
    try {
        while (true) {
            String message = in.readLine();
            if (message == null) break;
            System.out.println(timestamp() + " " + message);
        }
    } catch (IOException e) {
        System.err.println("Error reading from server: " + e.getMessage());
    }
});
readThread.start();

Thread writeThread = new Thread(() -> {
    try (BufferedReader userInput = new BufferedReader(new InputStreamReader(System.in))) {
        while (true) {
            String input = userInput.readLine();
            if (input == null) break;
            out.println(input);
        }
    } catch (IOException e) {
        System.err.println("Error sending to server: " + e.getMessage());
    }
});
writeThread.start();
```

#### Room:
- Rooms manage chat sessions by maintaining lists of users and moderators.
- A room can be created dynamically, with the first user becoming its moderator.
- Rooms handle adding or removing users and promote new moderators if needed.

```
`public void addUser(String user) {
	`users.add(user);` 
}` 
`public void removeUser(String user) {`
	`users.remove(user);` 
	`if (user.equals(moderator) && !users.isEmpty()) {` 
		`moderator = users.get(0);` 
	`}`
`}`
```

#### User:
- Represents a client connected to the server and handles their requests.
- Users are linked to unique tickets or pseudonyms and are associated with chat rooms they join.
- Implements rate-limiting and processes commands like `join`, `leave`, `send`, and `direct`.

```
@Override
public void run() {
    try {
        while (true) {
            String request = in.readLine();
            if (request == null) break;

            if (request.startsWith("pseudo ")) {
                pseudonym = request.substring(7);
                ticket = generateTicket();
                Server.addTicket(ticket, pseudonym);
                out.println("ticket " + ticket);
            } else if (request.startsWith("join ")) {
                String roomName = request.substring(5);
                joinRoom(roomName);
            }
        }
```



### Commands 

#### Server Commands

	pseudo <pseudonym>       // Generate and associate a ticket with a pseudonym
	ticket <ticket>          // Validate ticket and welcome user
	join <room_name>         // Join or create a room
	leave <room_name>        // Exit a room
	kick <room_name> <user>  // Remove a user from a room
	send <room_name> <msg>   // Send a message to a room
	direct <user> <msg>      // Send a private message to a user

#### Client Commands

	ident                     // Send ticket or pseudonym
	menu                      // Display connected users and available rooms
	list <room_name>          // List users in a room
	join <room_name>          // Join or create a room
	leave <room_name>         // Leave a room
	kick <room_name> <user>   // Notify kicked user
	room <user> <msg>         // Display a room message
	direct <user> <msg>       // Display a private message
	error <msg>               // Display error messages


### Conclusion: 

This phase of the project was dense with its materials it includes various topics such as 
Socket Programming, multi-threading, and synchronization principles to create a chatting server. This offered us a great experience that we haven't faced before with Java as a programming language. 

### References :

