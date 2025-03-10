package functions;

import java.io.Serializable;

public class Node implements Serializable {
	/**
	 * 
	 */
		private static final long serialVersionUID = 1L;
		//attributes
		private Student student;
		private Node rightNode;
		private Node leftNode;
	//Constructor
		public Node(Student student) {
			this.student = student;
			this.leftNode = null;
			this.rightNode = null;
		}
	//setters and Getters below this point
		
	//Student
		public Student getStudent() {
			return student;
		}
		public void setStudent(Student student) {
			this.student = student;
		}
	//right Node
		public Node getRightNode() {
			return rightNode;
		}
		public void setRightNode(Node rightNode) {
			this.rightNode = rightNode;
		}
	//left Node
		public Node getLeftNode() {
			return leftNode;
		}
		public void setLeftNode(Node leftNode) {
			this.leftNode = leftNode;
		}
}
