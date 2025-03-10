package functions;

import java.io.Serializable;
import java.util.ArrayList;
import java.util.Scanner;

public class Tree implements Serializable{
	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	private Node root;
	int size = nodeCounter(root);
	public Node getRoot() {
		return root;
	}
	public Tree(Node root) {
		this.root = root;
	}
	
	public Node find(int id) {
		Node cur = root;
		while(cur!=null) {
			if(id==cur.getStudent().getId()) {
				return cur;
			}
			else if(id>cur.getStudent().getId()) {
				cur = cur.getRightNode();
			}
			else {
				cur = cur.getLeftNode();
			}
		}
		return null;//if not found return null
	}
	
	public void insert(Student student) {
		Node cur = root;
		if (cur==null) {
			root = new Node(student);
		}
		else {
			boolean isLeftChild = false;
			Node parent=null;
			while(cur!=null) {
				if(student.getId()<cur.getStudent().getId()) {
					parent = cur;
					isLeftChild = true;
					cur=cur.getLeftNode();
				}
				else if(student.getId()>cur.getStudent().getId()){
					parent = cur;
					isLeftChild = false;
					cur = cur.getRightNode();
				}
				else {
					System.out.println("Node exists");
					return;
				}
			}
			if(isLeftChild) {
				parent.setLeftNode(new Node(student));
			}
			else {
				parent.setRightNode(new Node(student));
			}
		}
	}
	
	public Node update(int id) {
		Node cur = find(id);
		if(cur!=null) {
			Scanner input = new Scanner(System.in);
			boolean run = true;
			int in ;
			while(run) {
				System.out.println(cur.getStudent().toString());
				System.out.println("Input 1 to update Name");
				System.out.println("Input 2 to update Address");
				System.out.println("Input 3 to update ID");
				System.out.println("Input 4 to update GPA");
				System.out.println("Use invalid code to exit ");
				System.out.print("Input Code: ");
				in = input.nextInt();
				switch(in) {
					case 3:
						System.out.print("Enter ID: ");
						int userInput = input.nextInt();
						cur.getStudent().setId(userInput);

						break;
					case 1:
						System.out.print("Enter Name: ");
						String userInput1 = input.next();
						cur.getStudent().setName(userInput1);
						break;
					case 2:
						System.out.print("Enter Address: ");
						userInput1 = input.next();
						cur.getStudent().setAddress(userInput1);
						
						break;
					case 4:
						System.out.print("Enter GPA: ");
						double userInput3 = input.nextDouble();
						cur.getStudent().setGpa(userInput3);
						break;
						
					default: run=false;break;
				}
			}
			
		}
		return cur;
	}
	
	public boolean remove(int id) {
		Node cur = root;
		boolean isLeftChild = false;
		Node parent = null;
		//we run a while loop till Node cur is null
		while(cur!=null) {
			if(id==cur.getStudent().getId()) {
				if(cur.getLeftNode()==null && cur.getRightNode()==null) {
					if(parent==null) {
						this.root = null;
					}
					else if(isLeftChild) {
						parent.setLeftNode(null);
					}
					else {
						parent.setRightNode(null);
					}
				}
				else if(cur.getLeftNode()==null) {
					if(parent==null) {
						this.root = cur.getRightNode();
					}
					if(isLeftChild) {
						parent.setLeftNode(cur.getRightNode());
					}
					else {
						parent.setRightNode(cur.getRightNode());
					}
				}
				else if(cur.getRightNode()==null) {
					if(parent==null) {
						this.root = cur.getLeftNode();
					}
					if(isLeftChild) {
						parent.setLeftNode(cur.getLeftNode());
					}
					else {
						parent.setRightNode(cur.getLeftNode());
					}
				}
				else {
					Node successor = getSuccessor(cur);
					if(parent==null) {
						this.root = null;
					}
					else if(isLeftChild) {
						parent.setLeftNode(successor);
					}
					else {
						parent.setRightNode(successor);
					}
					successor.setLeftNode(cur.getLeftNode());
				}
				return true;
			}
			else if(id>cur.getStudent().getId()) {
				parent = cur;
				isLeftChild=false;
				cur=cur.getRightNode();
			}
			else {
				parent = cur;
				isLeftChild=true;
				cur=cur.getLeftNode();
			}

		}
		return false;
	}
	private Node getSuccessor(Node node) {
		Node successorParent = node;
		Node successor = node;
		Node current = node.getRightNode(); // go to right child
		while(current != null) // until no more
		{ // left children,
			successorParent = successor;
			successor = current;
			current = current.getLeftNode(); // go to left child
		}
		// if successor not
		if(successor != node.getRightNode()) // right child,
		{ // make connections
			successorParent.setLeftNode(successor.getRightNode());
			successor.setRightNode(node.getRightNode());
		}
		return successor;
	}
	
	//printStudent
	public void printStudent() {
		printIn(root);
	}
	private void printIn(Node node) {
		if (node == null) {
			return; 
		}
		printIn(node.getLeftNode());
		System.out.println(node.getStudent().toString());
		printIn(node.getRightNode());
	}
	
	//printTree
	public void printTree() {
		printPre(root);
	}
	private void printPre(Node node) {
		if(node==null) {
			return;
		}
		System.out.println(node.getStudent().toString());
		printPre(node.getLeftNode());
		printPre(node.getRightNode());
	}
	
	
	//studentWithGPA
	public ArrayList<Student> studentWithGPA(double gpa){
		ArrayList<Student> students = new ArrayList<>();
		students = inOrderRec(this.root,gpa,students);
		return students;
	}
	private ArrayList<Student> inOrderRec(Node node,double gpa,ArrayList<Student> students){
		
		if(node==null) {
			return students;
		}
		inOrderRec(node.getLeftNode(),gpa,students);
		if(node.getStudent().getGpa()<gpa) {
			students.add(node.getStudent());
		}
		inOrderRec(node.getRightNode(),gpa,students);
		
		return students;
	}
	//highestGpa
	public Student highestGPA(Student star) {
		ArrayList<Node> st = new ArrayList<>();
		 for(Node n:inOrderH(this.root,star.getGpa(),st)) {
			 if(n.getStudent().getGpa()>star.getGpa()) {
				 star = n.getStudent();
			 }
		 }
		 return star;
	}
	private ArrayList<Node> inOrderH(Node node,double gpa,ArrayList<Node> st) {
		if (node == null) {
			return st;
		}
		inOrderH(node.getLeftNode(),gpa,st);
		if(node.getStudent().getGpa()>gpa) {
			 st.add(node);
		}
		inOrderH(node.getRightNode(),gpa,st);
		return st;
		
		
	}
	
	//countNodes
	public int countNodes() {
		return nodeCounter(this.root);
	}
	private int nodeCounter(Node node) {
		if(node==null) {
			return 0;
		}
		else {
			int leftC = nodeCounter(node.getLeftNode());
			int rightC = nodeCounter(node.getRightNode());
			return 1+leftC+rightC;
		}

	}
	
	//personal methods
	public ArrayList<Student> studentsInTree(){
		ArrayList<Student> students = new ArrayList<>();
		return giveAll(this.root,students);
	}
	private ArrayList<Student> giveAll(Node node,ArrayList<Student> students){
			
			if(node==null) {
				return students;
			}
			giveAll(node.getLeftNode(),students);
			students.add(node.getStudent());
			giveAll(node.getRightNode(),students);
			
			return students;
	}
}