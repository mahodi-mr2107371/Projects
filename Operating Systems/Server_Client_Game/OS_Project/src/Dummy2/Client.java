package Dummy2;

import java.io.*;
import java.net.*;
import java.util.*;

public class Client {

	
	 private static final String SERVER_ADDRESS = "localhost"; //10.20.42.24
	    private static final int SERVER_PORT = 13337;
	    private static final Scanner scanner = new Scanner(System.in);

	    public static void main(String[] args) {
	        try (Socket socket = new Socket(SERVER_ADDRESS, SERVER_PORT)) {
	            BufferedReader in = new BufferedReader(new InputStreamReader(socket.getInputStream()));
	            PrintWriter out = new PrintWriter(socket.getOutputStream(), true);


	            
	            // Get ticket from server
	            String from_Server = in.readLine();
	            System.out.println(from_Server);
	            
	            System.out.println();
                String command = scanner.nextLine();
                out.println(command);
//                
               String response;
//                for (int i=0 ; i<14;i++) {

                
                while (true) {
                	response = in.readLine();
					if( !(response.equals("END_OF_TRANS")) )  {
						System.out.println(response);
					}
					else {

						break;
					}	
				}
                
	            // Handle user input and interaction with server
	            while (true) {
	            	System.out.println();
	                command = scanner.nextLine();
	                out.println(command);

	                // Handle server responses
	                 response = in.readLine();
	                System.out.println("Server response: " + response);

	                // Add more logic to handle other commands and responses
	            }
	        } catch (IOException e) {
	            e.printStackTrace();
	        }
	    }
}
