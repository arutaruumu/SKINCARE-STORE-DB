# ERD
![Screenshot 2024-07-20 112937](https://github.com/user-attachments/assets/6722c074-781f-4174-a5d6-e4f9a27a0991)

The database that our group created is the database for the skincare store system. The following is an explanation of the main structure of the database;
# Relationship between tables
- Customers to orders : one-to-many (one customer can place multiple orders)<br/>
- Order to OrderDetails : one-to-many (one order can have multiple order details)<br/>
- Product to OrderDetails : one-to-many (one product can appear in many order details)<br/>
- Product to Categories via ProducutCategories : many-to-many (many products can be in many categories)<br/>
- Brands to Products : one-to-many (one brand has many products)<br/>
- Products to reviews : one-to-many (One product can have many reviews)<br/>
- Customers to reviews: one-to-many (one customer can leave many reviews)<br/>
- Customers to Addresses: one-to-many (one customer can have many addresses)<br/>
- Orders to payments : one-to-many (one order can have many payments)<br/>
- Suppliers to orders via ProductSuppliers : many-to-many (many suppliers can supply many products)<br/>
