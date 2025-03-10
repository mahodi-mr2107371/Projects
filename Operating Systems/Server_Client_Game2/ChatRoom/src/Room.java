import java.util.*;

public class Room {
    String name;
    String moderator;
    List<String> users;

    public Room(String name, String moderator) {
        this.name = name;
        this.moderator = moderator;
        this.users = new ArrayList<>();
        this.users.add(moderator);
    }

    public void addUser(String user) {
        users.add(user);
    }

    public void removeUser(String user) {
        users.remove(user);
        if (user.equals(moderator) && !users.isEmpty()) {
            moderator = users.get(0);
        }
    }

    public boolean isEmpty() {
        return users.isEmpty();
    }

}