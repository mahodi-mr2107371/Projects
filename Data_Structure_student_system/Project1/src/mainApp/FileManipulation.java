package mainApp;

import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.ObjectInputStream;
import java.io.ObjectOutputStream;

import functions.TreeTable;

public class FileManipulation {
    String fileName;
    public FileManipulation(String fileName) {
        this.fileName = fileName+".txt";
    }
    
    public TreeTable loadFile() throws IOException, ClassNotFoundException {
        ObjectInputStream ois = new ObjectInputStream(new FileInputStream(this.fileName));
        TreeTable treeTable = (TreeTable) ois.readObject();
        ois.close();
        return treeTable;
    }
    
    public void writeFile(TreeTable treeTable) throws IOException {
        
        File file = new File(this.fileName);
        if(!file.exists()) {
        	ObjectOutputStream oos = new ObjectOutputStream(new FileOutputStream(this.fileName));
        	oos.writeObject(treeTable);
            oos.close();
        }
        else {
        	file.delete();
        	ObjectOutputStream oos = new ObjectOutputStream(new FileOutputStream(this.fileName));
        	oos.writeObject(treeTable);
            oos.close();
        }
    }
}
