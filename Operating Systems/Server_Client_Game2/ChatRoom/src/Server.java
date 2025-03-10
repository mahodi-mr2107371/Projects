import java.io.BufferedReader;
import java.io.File;
import java.io.FileReader;
import java.io.FileWriter;
import java.io.IOException;
import java.io.PrintWriter;
import java.net.ServerSocket;
import java.net.Socket;
import java.util.Collections;
import java.util.HashMap;
import java.util.Map;

public class Server {
    public static final int PORT = 13337;
    static Map<String, User> users = Collections.synchronizedMap(new HashMap<>());
    static Map<String, User> pseudonyms = Collections.synchronizedMap(new HashMap<>());
    static Map<String, String> tickets = Collections.synchronizedMap(new HashMap<>());
    static Map<String, Room> rooms = Collections.synchronizedMap(new HashMap<>());
    static int ticketCounter = 0;

    public static void main(String[] args) throws IOException {
        File ticketFile = new File("tickets.txt");
        if (ticketFile.exists()) {
            try (BufferedReader reader = new BufferedReader(new FileReader(ticketFile))) {
                String line = reader.readLine();
                while (line != null) {
                    tickets.put(line.split("=")[0], line.split("=")[1]);
                    // System.out.println("Ticket is :"+line.split("=")[0]+" pseudonym is:
                    // "+line.split("=")[1]);
                    line = reader.readLine();
                }
            } catch (IOException e) {
                System.err.println("Error loading ticket from file: " + e.getMessage());
            }
        }

        @SuppressWarnings("resource")
        ServerSocket serverSocket = new ServerSocket(PORT);
        System.out.println(
                "Server started on port " + PORT + " Host name: " + serverSocket.getInetAddress().getHostName());
        while (true) {
            Socket clientSocket = serverSocket.accept();
            User user = new User(clientSocket);
            Thread userThread = new Thread(user);
            userThread.start();
            // Thread checkSocket = new Thread(() -> {
            // User usr = user;
            // while (true) {
            // if (usr.socket.isClosed()) {
            // System.out.println(users);
            // users.remove(usr.ticket);
            // break;
            // }
            // }
            // });
            // checkSocket.start();
        }
    }

    public static void addTicket(String ticket, String pseudonym) {
        try (PrintWriter writer = new PrintWriter(new FileWriter("tickets.txt", true))) {
            writer.println(ticket + "=" + pseudonym);
            tickets.put(ticket, pseudonym);
        } catch (IOException e) {
            System.err.println("Error saving tickets to file: " + e.getMessage());
        }
    }

    public static void addUserToPseudonyms(String pseudonym, User user) {
        synchronized (pseudonyms) {
            if (pseudonyms.get(pseudonym) == null) {
                pseudonyms.put(pseudonym, user);
            }
        }
    }
}