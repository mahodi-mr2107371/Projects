package functions;

import java.io.Serializable;
import java.util.ArrayList;

public class TreeTable implements Serializable {
	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	public Tree[] treeTable;
	public TreeTable() {
		treeTable = new Tree[25];
	}
	//methods below
	
	//find
		public Student find(int id) {
			int year = id/100000;
			int hashIndex = year%25;
			Tree cur = treeTable[hashIndex];
			Node node = cur.find(id);//gets the node of the student
			if(node==null){
				return null;
			}
			else {
				return node.getStudent();
			}
		}
		
	//insert
		public void insert(Student student) {
			if(student.getId()/1000000000==0) {
				int year = student.getId()/100000;
				int hashIndex = year%25;
				if(treeTable[hashIndex]==null) {
					treeTable[hashIndex] = new Tree(null);
				}
				treeTable[hashIndex].insert(student);
			}
			else {
				System.out.println("Invalid Student ID");
			}
		}
		
	//update
		public Student update(int id) {
			int year = id/100000;
			int hashIndex = year%25;
			Tree tree = treeTable[hashIndex];
			Node node = tree.update(id);
			if(node!=null) {
				return node.getStudent();
			}
			return null;
		}
		
	//remove
		public boolean remove(int id) {
			int year = id/100000;
			int hashIndex = year%25;
			Tree tree = treeTable[hashIndex];
			boolean feed = tree.remove(id);
			if(feed){
				System.out.println(feed);
				return feed;
			}
			else {
				System.out.println(feed);
				return feed;
			}
		}
		
	//printStudent
		public void printStudent(int year) {
			int index = year%25;
			Tree cell = treeTable[index];
			if(cell!=null) {
				cell.printStudent();
			}
			else {
				System.out.println("No students in this year");
			}
			
		}
	
	//printAll
		public void printAll() {
			for(int i=0;i< treeTable.length;i++) {
				if(treeTable[i]!=null) {
					System.out.println(2000+i);
					treeTable[i].printTree();
				}
				else {
					System.out.println(2000+i);
					System.out.println("NULL");
				}
			}
		}
	
	//studentWithGpa
	public ArrayList<Student> studentWithGPA(double gpa) {
		ArrayList<Student> students = new ArrayList<>();
		for(Tree tree:treeTable) {
			if(tree!=null) {
				for(Student student:tree.studentWithGPA(gpa)) {
					students.add(student);
				}
			}
		}
		return students;
	}
	
	//student with highestGPA
	public Student highestGPA() {
		Student star=null;
		for(Tree tree:treeTable) {
			if(tree!=null) {
				star = tree.getRoot().getStudent();
				break;
			}
		}
		if(star!=null) {
			for(Tree tree:treeTable) {
				if(tree!=null) {
					Student newSTD = tree.highestGPA(star);
					if(star.getGpa()<newSTD.getGpa()) {
						star = newSTD;
					}
				}
			}
		}
		return star;
	}
	
	//highestGPA parameter
	public Student highestGPA(int year) {
		Tree tree = treeTable[year % 25];
		if(tree!=null) {
			Student star = tree.getRoot().getStudent();
			return tree.highestGPA(star);
		}
		return null;
	}
	
	//numberStudents method
	public int numberStudents() {
		int count =0;
		for(Tree tree:treeTable) {
			if(tree!=null) {
				count+=tree.countNodes();
			}
		}
		return count;
	}
	
	//parameter numberStudents
	public int numberStudents(int year) {
		//passes the hash index from the year to the hash table and use the
		//function countNodes of Tree Class to count nodes
		return treeTable[year%25].countNodes();
	}
		
		
}
