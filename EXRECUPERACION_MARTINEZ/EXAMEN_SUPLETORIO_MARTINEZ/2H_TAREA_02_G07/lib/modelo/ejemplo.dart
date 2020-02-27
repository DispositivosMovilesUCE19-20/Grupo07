class Sale {
  int employeeId;
  double price;
  Sale(this.employeeId, this.price);
}

class Employee {
  int id;
  List<Sale> sales;
  Employee (this.id, this.sales);  
}

