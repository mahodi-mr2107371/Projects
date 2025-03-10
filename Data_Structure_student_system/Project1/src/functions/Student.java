package functions;

import java.io.Serializable;

public class Student implements Serializable {
	
	/**
	 * 
	 */
		private static final long serialVersionUID = 1L;
		//attributes of Student class below
		private String name,address;
		private int id;
		private double gpa;
			
	//Student Constructor below
		public Student(String name,String address,int id,double gpa) {
			this.name = name;
			this.setAddress(address);
			this.setId(id);
			this.setGpa(gpa);
		}
	
	//Getter and Setters below this point
		
	//name
		public String getName() {
			return name;
		}
	
		public void setName(String name) {
			this.name = name;
		}
	
	//address
		public String getAddress() {
			return address;
		}
		
		public void setAddress(String address) {
			this.address = address;
		}
	
	//id
		public int getId() {
			return id;
		}
	
		@Override
		public String toString() {
			return "Student [name=" + name + ", address=" + address + ", id=" + id + ", gpa=" + gpa + "]";
		}

		public void setId(int id) {
			this.id = id;
		}
		
	//gpa
		public double getGpa() {
			return gpa;
		}

		public void setGpa(double gpa) {
			this.gpa = gpa;
		}
		

}
