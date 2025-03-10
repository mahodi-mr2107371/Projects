import java.io.*;
import java.net.*;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.security.SecureRandom;
import java.util.*;

public class User implements Runnable {
    Socket socket;
    private PrintWriter out;
    private BufferedReader in;
    String ticket;
    String pseudonym;
    String currentRoom;

    public User(Socket socket) {
        this.socket = socket;
        try {
            out = new PrintWriter(socket.getOutputStream(), true);
            in = new BufferedReader(new InputStreamReader(socket.getInputStream()));

        } catch (IOException e) {
            e.printStackTrace();
        }
    }

    @Override
    public void run() {
        try {
            // log in and varification here
            out.println("info pseudo pseudonym\tgenerates new ticket\r\n" + //
                    "info ticket ticket\tvalidates provided ticket");

            String request = in.readLine();
            // keep in loop if request is not pseudo or ticker, if exit then exit the
            // program
            while (true) {
                synchronized (Server.users) {
                    if (!request.startsWith("pseudo ") || !request.startsWith("ticket ")
                            || !request.startsWith("exit")) {
                        if (request.startsWith("pseudo ")) {
                            pseudonym = request.substring(7);
                            if (Server.tickets.containsValue(pseudonym)) {
                                out.println("error pseudonym exits, use ticket to login");
                            } else {
                                ticket = generate(String.valueOf(Server.ticketCounter++));
                                Server.addTicket(ticket, pseudonym);
                                Server.addUserToPseudonyms(pseudonym, this);
                                Server.users.put(ticket, this);
                                out.println("ticket " + ticket);
                                out.println(
                                        "info welcome " + pseudonym + "!");
                                out.println(
                                        "info join room");
                                out.println(
                                        "info direct user message");
                                String mn = "Users: ";
                                for (User usr : Server.users.values()) {
                                    if (mn.split(" ").length == 1) {
                                        mn = mn + usr.pseudonym;
                                    } else {
                                        mn = mn + ", " + usr.pseudonym;
                                    }
                                }
                                out.println("menu " + mn);
                                mn = "Rooms: ";
                                for (String room : Server.rooms.keySet()) {
                                    if (mn.split(" ").length == 1) {
                                        mn = mn + room;
                                    } else {
                                        mn = mn + ", " + room;
                                    }
                                }
                                out.println("menu " + mn);
                                break;
                            }
                        } else if (request.startsWith("ticket ")) {
                            ticket = request.substring(7);
                            if (Server.users.get(ticket) == null) {
                                if (Server.tickets.containsKey(ticket)) {
                                    pseudonym = Server.tickets.get(ticket);
                                    Server.addUserToPseudonyms(pseudonym, this);
                                    Server.users.put(ticket, this);
                                    out.println(
                                            "info welcome " + pseudonym + "!");
                                    out.println(
                                            "info join room");
                                    out.println(
                                            "info leave room");
                                    out.println(
                                            "info kick room user reason");
                                    out.println(
                                            "info Send room message");
                                    out.println(
                                            "info direct user message");

                                    String mn = "Users: ";
                                    for (User usr : Server.users.values()) {
                                        if (mn.split(" ").length == 1) {
                                            mn = mn + usr.pseudonym;
                                        } else {
                                            mn = mn + ", " + usr.pseudonym;
                                        }
                                    }
                                    out.println("menu " + mn);
                                    mn = "Rooms: ";
                                    for (String room : Server.rooms.keySet()) {
                                        if (mn.split(" ").length == 1) {
                                            mn = mn + room;
                                        } else {
                                            mn = mn + ", " + room;
                                        }
                                    }
                                    out.println("menu " + mn);
                                    break;
                                } else {
                                    out.println("error Invalid ticket");
                                }
                            } else {
                                out.println("error User already logged in");
                            }
                        } else if (request.startsWith("exit")) {
                            out.println("exit");
                            this.socket.close();
                            break;
                        }
                    }
                    out.println("info pseudo pseudonym\tgenerates new ticket\r\n" + //
                            "info ticket ticket\tvalidates provided ticket");
                    request = in.readLine();
                }
            }
            if (request.startsWith("exit")) {
                return;
            }
            request = in.readLine();
            // Main communication loop
            while (true) {
                // Rate limiting
                synchronized (this) {
                    long currentTime = System.currentTimeMillis();
                    if (currentTime - lastRequestTime < 250) {
                        try {
                            wait(250 - (currentTime - lastRequestTime));
                        } catch (InterruptedException e) {
                            Thread.currentThread().interrupt();
                        }
                    }
                    lastRequestTime = currentTime;
                }

                // Process commands
                if (request.startsWith("join ")) {
                    String roomName = request.substring(5);
                    joinRoom(roomName);
                } else if (request.startsWith("leave ")) {
                    String roomName = request.substring(6);
                    leaveRoom(roomName);
                } else if (request.startsWith("kick ")) {
                    String[] parts = request.substring(5).split(" ");
                    if (parts.length < 3) {
                        out.println("error Invalid kick command format");
                        continue;
                    }
                    String roomName = parts[0];
                    String userNameToKick = parts[1];
                    String reason = request.substring(5).substring(roomName.length() + 1)
                            .substring(userNameToKick.length() + 1);
                    kickUser(roomName, userNameToKick, reason);
                } else if (request.startsWith("send ")) {
                    String[] roomAndMessage = request.substring(5).split(" ");

                    if (roomAndMessage.length < 2) {
                        out.println("error Invalid send command format");
                        continue;
                    }
                    String roomName = roomAndMessage[0];
                    String message = request.substring(5).substring(roomName.length() + 1);
                    sendMessage(roomName, message);
                } else if (request.startsWith("direct ")) {
                    String[] parts = request.substring(7).split(" ");
                    if (parts.length < 2) {
                        out.println("error Invalid direct command format");
                        continue;
                    }

                    String userName = parts[0];
                    String message = request.substring(7).substring(userName.length() + 1);
                    sendDirectMessage(userName, message);
                } else if (request != null || request.isEmpty()) {
                    out.println("error Invalid command");
                }
                request = in.readLine();
            }

        } catch (

        IOException e) {
            System.err.println("Error handling user: " + e.getMessage());
        } finally {
            try {
                socket.close();
            } catch (IOException e) {
                System.err.println("Error closing socket: " + e.getMessage());
            }
            // Remove the user from Server.users and Server.pseudonyms
            synchronized (Server.users) {
                Server.users.remove(ticket);
                synchronized (Server.pseudonyms) {
                    User user = Server.pseudonyms.get(pseudonym);
                    if (user != null) {
                        Server.pseudonyms.remove(pseudonym);
                    }
                }
            }
        }

    }

    // Ticket generation method
    public static String generate(String seq) {
        // Use SecureRandom instead of Math.random for cryptographic randomness
        SecureRandom secureRandom = new SecureRandom();

        // Pad or truncate input to ensure it is exactly 32 characters
        String paddedSeq = String.format("%-32s", seq).substring(0, 32);

        byte[] hash = paddedSeq.getBytes();

        try {
            // Hash the input a random number of times (1 to 64)
            int iterations = secureRandom.nextInt(64) + 1;
            MessageDigest digest = MessageDigest.getInstance("SHA-256");

            for (int i = 0; i < iterations; ++i) {
                hash = digest.digest(hash);
            }
        } catch (NoSuchAlgorithmException e) {
            throw new RuntimeException("SHA-256 algorithm not available", e);
        }

        // Convert hash to hexadecimal and return the last 6 characters
        String hexHash = HexFormat.of().formatHex(hash);
        String val = hexHash.substring(hexHash.length() - 6);
        return val;
    }

    // Room management methods
    private void joinRoom(String roomName) {
        // If the user is already in a room, leave it first
        if (currentRoom != null) {
            leaveRoom(currentRoom);
        }

        synchronized (Server.rooms) {
            Room room = Server.rooms.get(roomName);
            if (room == null) {
                // Create a new room with this user as moderator
                room = new Room(roomName, pseudonym);
                Server.rooms.put(roomName, room);
                out.println("info Created and joined: " + roomName);
            } else {
                synchronized (room.users) {
                    room.addUser(pseudonym);
                    out.println("info Joined room: " + roomName);
                }
            }

            currentRoom = roomName;
            // Notify all users in the room that a new user has joined
            synchronized (Server.pseudonyms) {
                List<User> roomUsers = new ArrayList<>();
                for (String userPseudonym : room.users) {
                    User user = Server.pseudonyms.get(userPseudonym);
                    if (user.pseudonym != this.pseudonym) {
                        roomUsers.add(user);
                    }
                }
                for (User user : roomUsers) {
                    user.out.println("join " + roomName + " " + pseudonym);
                }
            }
        }
    }

    private void leaveRoom(String roomName) {
        synchronized (Server.rooms) {
            Room room = Server.rooms.get(roomName);
            if (room == null) {
                out.println("error Room does not exist");
                return;
            }
            synchronized (room.users) {
                if (!room.users.contains(pseudonym)) {
                    out.println("error You are not in this room");
                    return;
                }
                room.removeUser(pseudonym);
                // If the user was the moderator and there are other users, assign a new
                // moderator
                if (room.moderator.equals(pseudonym) && !room.users.isEmpty()) {
                    String newModerator = room.users.get(0);
                    room.moderator = newModerator;

                }
                // If the room is now empty, remove it from Server.rooms
                if (room.isEmpty()) {
                    Server.rooms.remove(roomName);
                }
                // Notify all users in the room that this user has left
                synchronized (Server.pseudonyms) {
                    List<User> roomUsers = new ArrayList<>();
                    for (String userPseudonym : room.users) {
                        User user = Server.pseudonyms.get(userPseudonym);
                        if (user != null) {
                            roomUsers.add(user);
                        }
                    }
                    roomUsers.add(Server.pseudonyms.get(pseudonym));
                    for (User user : roomUsers) {
                        user.out.println("leave " + roomName + " " + pseudonym);
                        user.out.println("info " + room.moderator + " is the moderator");
                    }
                }
                currentRoom = null;
            }
        }
    }

    private void kickUser(String roomName, String userNameToKick, String reason) {
        synchronized (Server.rooms) {
            Room room = Server.rooms.get(roomName);
            if (room == null) {
                out.println("error Room does not exist");
                return;
            }
            synchronized (room.users) {
                if (!room.users.contains(pseudonym)) {
                    out.println("error You are not in this room");
                    return;
                }
                if (!room.moderator.equals(pseudonym)) {
                    out.println("error You are not the moderator");
                    return;
                }
                if (!room.users.contains(userNameToKick)) {
                    out.println("error User not in this room");
                    return;
                }
                room.removeUser(userNameToKick);
                // If the user being kicked was the moderator, assign a new moderator
                if (room.moderator.equals(userNameToKick) && !room.users.isEmpty()) {
                    String newModerator = room.users.get(0);
                    room.moderator = newModerator;
                }
                // If the room is now empty, remove it from Server.rooms
                if (room.isEmpty()) {
                    Server.rooms.remove(roomName);
                }
                // Notify all users in the room that the user has been kicked
                synchronized (Server.pseudonyms) {
                    List<User> roomUsers = new ArrayList<>();
                    for (String userPseudonym : room.users) {
                        User user = Server.pseudonyms.get(userPseudonym);
                        if (user != null) {
                            roomUsers.add(user);
                        }
                    }
                    roomUsers.add(Server.pseudonyms.get(userNameToKick));
                    for (User user : roomUsers) {
                        user.out.println("kick " + roomName + " " + userNameToKick);
                    }

                }
            }
        }
    }

    private void sendMessage(String roomName, String message) {
        synchronized (Server.rooms) {
            Room room = Server.rooms.get(roomName);
            if (room == null) {
                out.println("error Room does not exist");
                return;
            }
            synchronized (room.users) {
                if (!room.users.contains(pseudonym)) {
                    out.println("error You are not in this room");
                    return;
                }
                // Send the message to all users in the room
                synchronized (Server.pseudonyms) {
                    List<User> roomUsers = new ArrayList<>();
                    for (String userPseudonym : room.users) {
                        User user = Server.pseudonyms.get(userPseudonym);
                        if (user != null) {
                            roomUsers.add(user);
                        }
                    }
                    for (User user : roomUsers) {
                        user.out.println("room " + pseudonym + " " + message);
                    }
                }
            }
        }
    }

    private void sendDirectMessage(String userName, String message) {
        if (userName.equals(pseudonym)) {
            out.println("error You cannot send a direct message to yourself");
            return;
        }
        synchronized (Server.pseudonyms) {
            User user = Server.pseudonyms.get(userName);
            if (user == null) {
                out.println("error User not found");
                return;
            }
            user.out.println("direct " + pseudonym + " " + message);

        }
    }

    // Rate limiting timestamp
    private long lastRequestTime = 0;
}