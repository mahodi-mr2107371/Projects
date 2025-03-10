package mainApp;

import java.io.IOException;
import java.io.Serializable;
import java.util.Scanner;

import functions.*;

public class Tester implements Serializable{

	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;

	public static void main(String[] args) {
		/*
		//Creating Student Objects
			Student student1 = new Student("NAME","ADDRESS",202107360,3.0);
			Student student2 = new Student("NAME","ADDRESS",202107361,3.0);
			Student student3 = new Student("NAME","ADDRESS",202107362,2.0);
			Student student4 = new Student("NAME","ADDRESS",202007360,3.0);
			Student student5 = new Student("NAME","ADDRESS",202007361,4.0);
			Student student6 = new Student("NAME","ADDRESS",202007362,3.0);
			Student student7 = new Student("NAME","ADDRESS",201907360,2.0);
			Student student8 = new Student("NAME","ADDRESS",201907361,2.0);
			Student student9 = new Student("NAME","ADDRESS",201907362,2.0);
			Student student10 = new Student("NAME","ADDRESS",201807360,1.0);
			Student student11 = new Student("NAME","ADDRESS",201807361,3.0);
			Student student12 = new Student("NAME","ADDRESS",201807362,3.0);
			Student student13 = new Student("NAME","ADDRESS",201707360,1.5);
			Student student14 = new Student("NAME","ADDRESS",201707361,3.0);
			Student student15 = new Student("NAME","ADDRESS",201707362,2.0);
			Student student16 = new Student("NAME","ADDRESS",201607360,1.0);
			Student student17 = new Student("NAME","ADDRESS",201607361,3.0);
			Student student18 = new Student("NAME","ADDRESS",201607362,1.0);
			Student student19 = new Student("NAME","ADDRESS",201507360,2.0);
			Student student20= new Student("NAME","ADDRESS",201507361,3.0);
			Student student21 = new Student("NAME","ADDRESS",201507362,2.0);
		
		//Creating an Array of Students to make it easier to insert
			Student[] students = {student1,student2,student3,student4,student5,student6,student7,student8,student9,student10,student11,student12,student13,student14,student15,student16,student17,student18,student19,student20,student21};
		
		//creating HashTable called From TreeTable Class, our Data base
			TreeTable hashTable = new TreeTable();
			
		//inserting all students in hashTable
			for(Student student:students) {
				hashTable.insert(student);
			}
		*/
		TreeTable hashTable=null;
		FileManipulation file = new FileManipulation("file");
		try {
			hashTable=file.loadFile();
		} catch (IOException | ClassNotFoundException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		//Testing Methods (Note: insert has been tested above)
			boolean b = true;
			Scanner sc = new Scanner(System.in);
			int input;
			System.out.println("\n--- Menu ---");
			System.out.println("1. Insert student");
			System.out.println("2. Find student by ID");
			System.out.println("3. Update student");
			System.out.println("4. Remove student by ID");
			System.out.println("5. Print students admitted in a specific year");
			System.out.println("6. Print all students");
			System.out.println("7. Find students with GPA below a specific value");
			System.out.println("8. Get student with the highest GPA over 25 years");
			System.out.println("9. Get student with the highest GPA in a specific year");
			System.out.println("10. Get overall students count over 25 years");
			System.out.println("11. Get overall students count in a specific year");
			System.out.println("Use invalid input to exit");
			
			while(b) {
				System.out.print("Select One of the Listed values: ");
				input = sc.nextInt();
				switch(input){
					case 1:
						
						//Creating Scanner
						System.out.println("Inserting Student");
						try {

							//name input
							System.out.print("Insert Student Name: ");
							String name = sc.next();
							
							//address input
							System.out.print("Insert Student Address: ");
							String address = sc.next();
							
							//ID input
							System.out.print("Insert Student ID: ");
							int id = sc.nextInt();
							
							//GPA input
							System.out.print("Insert Student Gpa: ");
							double gpa = sc.nextDouble();
							
							//creating Student and inserting at the same time
							hashTable.insert(new Student(name,address,id,gpa));
						}catch(Exception e) {
							System.out.println(e);
						}
						
						//hashTable.treeTable[(id/100000)%25].printTree();
						
						break;
			
					case 2:
						System.out.print("Insert Student ID: ");
						try {
							int id = sc.nextInt();
							
							if(hashTable.find(id)!=null) {//condition found
								System.out.println("ID FOUND:");
								System.out.println(hashTable.find(id));
							}
							else {//condition not found
								System.out.println("ID not FOUND");
							}
						}catch(Exception e) {
							System.out.println(e);
						}
						break;
						
					case 3: 
						System.out.print("Input ID that needs Updating: ");
						try {
							int id = sc.nextInt();
							Student student = hashTable.find(id);
							if(student!=null) {
								hashTable.update(id);
							}
							else {
								System.out.println("Student Not Found");
							}
						}catch(Exception e) {
							System.out.println(e);
						}
						
						break;
					case 4:
						
						System.out.print("Enter ID of Student: ");
						try {
							int id= sc.nextInt();
							hashTable.remove(id);
						}catch(Exception e){
							System.out.println(e);
						}
						
						break;
					case 5:
						
						System.out.print("Enter Year: ");
						try {
							int year = sc.nextInt();
							hashTable.printStudent(year);
						}catch(Exception e){
							System.out.println(e);
						}
						
						break;
					case 6:
						System.out.println("Students in each year:");
						try {
							hashTable.printAll();
						}catch(Exception e){
							System.out.println(e);
						}
						break;
					case 7:
						System.out.println("Enter GPA: ");
						
						try {
							double gpa = sc.nextDouble();
							for(Student s:hashTable.studentWithGPA(gpa)) {
								System.out.println(s.toString());
							}
						}catch(Exception e) {
							System.out.println(e);
						}
						break;
					case 8:
						try {
							System.out.println(hashTable.highestGPA());
						}catch(Exception e) {
							System.out.println(e);
						}
						break;
					case 9: 
						System.out.print("Enter the year: ");
						
						try {
							int year = sc.nextInt();
							Student student = hashTable.highestGPA(year);
							System.out.println(student.toString());
						}catch(Exception e) {
							System.out.println(e);
						}
						break;
					case 10:
						try {
							System.out.println(hashTable.numberStudents());
						}catch(Exception e){
							System.out.println(e);
						}
						break;
					case 11:
						System.out.print("Enter year: ");
						
						try {
							int year = sc.nextInt();
							System.out.println(hashTable.numberStudents(year));
						}catch(Exception e) {
							System.out.println(e);
						}
						break;
					default: b=false;break;	
				}	
			}
			sc.close();
			try {
				file.writeFile(hashTable);
			} catch (IOException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
		}
	

}
