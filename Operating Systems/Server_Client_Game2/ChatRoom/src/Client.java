
import java.io.*;
import java.net.*;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;

public class Client {
    private Socket socket;
    private PrintWriter out;
    private BufferedReader in;
    private String ticket;

    public Client(String host, int port) throws IOException {
        socket = new Socket(host, port);
        out = new PrintWriter(socket.getOutputStream(), true);
        in = new BufferedReader(new InputStreamReader(socket.getInputStream()));
    }

    public void run() throws IOException {

        // Start threads for reading and writing
        Thread readThread = new Thread(() -> {
            try {
                while (true) {
                    synchronized (Server.users) {
                        String message = in.readLine();
                        if (message == null)
                            break;
                        if (message.startsWith("ticket")) {
                            ticket = message.substring(7);
                            this.ticket = message.substring(7);
                            saveTicketToFile(ticket);
                        } else if (message.startsWith("ident")) {
                            out.println(Server.tickets.get(this.ticket));
                        } else if (message.startsWith("menu")) {
                            System.out.println(timestamp() + " [MENU]: " + message.substring(5));
                        } else if (message.startsWith("list")) {
                            System.out.println(timestamp() + " users in " + message.split(" ")[1]
                                    + Server.rooms
                                            .get(Server.pseudonyms.get(Server.tickets.get(ticket)).currentRoom).users
                                            .toString());
                        } else if (message.startsWith("join")) {
                            System.out
                                    .println(timestamp() + " " + message.split(" ")[2] + " joined "
                                            + message.split(" ")[1]);
                        } else if (message.startsWith("leave")) {
                            System.out.println(
                                    timestamp() + " " + message.split(" ")[2] + " left " + message.split(" ")[1]);
                        } else if (message.startsWith("kick")) {
                            System.out.println(
                                    timestamp() + " " + message.split(" ")[2] + " was kicked from "
                                            + message.split(" ")[1]);
                        } else if (message.startsWith("room")) {
                            System.out.println(
                                    timestamp() + " " + message.split(" ")[1] + " says: "
                                            + message.substring(5).substring(message.split(" ")[1].length() + 1));
                        } else if (message.startsWith("direct")) {
                            System.out
                                    .println(timestamp() + " " + message.split(" ")[1] + " whispered: "
                                            + message.substring(7).substring(message.split(" ")[1].length() + 1));
                        } else if (message.startsWith("info")) {
                            System.out.println(timestamp() + " [INFO]: " + message.substring(5));
                        } else if (message.startsWith("error")) {
                            System.out.println(timestamp() + " [ERROR]: " + message.substring(6));
                        } else if (message.startsWith("exit")) {
                            socket.close();
                            break;
                        } else {
                            System.out.println(timestamp() + " " + message);
                        }
                    }
                }
            } catch (IOException e) {
                System.err.println("Error reading from server: " + e.getMessage());
            }
        });
        readThread.start();

        Thread writeThread = new Thread(() -> {
            try {
                BufferedReader userInput = new BufferedReader(new InputStreamReader(System.in));
                while (true) {
                    String input = userInput.readLine();
                    if (input == null)
                        break;
                    out.println(input);
                    if (input.startsWith("exit")) {
                        break;
                    }
                }
            } catch (IOException e) {
                System.err.println("Error sending to server: " + e.getMessage());
            }
        });
        writeThread.start();
    }

    // Timestamp generation
    public static String timestamp() {
        return LocalDateTime.now().format(DateTimeFormatter.ISO_LOCAL_DATE_TIME);
    }

    private void saveTicketToFile(String ticket) {
        try (PrintWriter writer = new PrintWriter(new FileWriter("ticket.txt"))) {
            writer.println(ticket);
        } catch (IOException e) {
            System.err.println("Error saving ticket to file: " + e.getMessage());
        }
    }

    public static void main(String[] args) throws IOException {
        if (args.length != 2) {
            System.err.println("Usage: java Client [host] [port]");
            return;
        }
        String host = args[0];
        int port = Integer.parseInt(args[1]);
        Client client = new Client(host, port);
        client.run();
    }
}