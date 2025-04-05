import pandas as pd
from sqlalchemy import create_engine
import matplotlib.pyplot as plt
import seaborn as sns

# PostgreSQL connection string from DBT example
db_connection_url = "postgresql://u5h2s7shhkqeo5:pf373bc6d5cddc47f95a938f4914e895c868ca1e01fc5eeb79ad7413b71c6db40@c97r84s7psuajm.cluster-czrs8kj4isg7.us-east-1.rds.amazonaws.com:5432/d9snqvovhsjpqs"

# Create SQLAlchemy engine
engine = create_engine(db_connection_url)

# Test connection and list the tables
tables = pd.read_sql("SELECT table_name FROM information_schema.tables WHERE table_schema='public'", engine)
print(tables)

# Query sales data
sales_query = '''
SELECT order_date, SUM(total_price) as total_revenue, COUNT(order_id) as total_orders
FROM stg_sales
GROUP BY order_date
ORDER BY order_date;
'''
sales_data = pd.read_sql(sales_query, engine)

# Display the first few rows
print(sales_data.head())

# Plot total revenue over time
plt.figure(figsize=(10, 6))
sns.lineplot(data=sales_data, x='order_date', y='total_revenue', marker='o')
plt.title('Total Revenue Over Time')
plt.xlabel('Order Date')
plt.ylabel('Total Revenue ($)')
plt.xticks(rotation=45)
plt.tight_layout()
plt.show()

# Plot total orders over time
plt.figure(figsize=(10, 6))
sns.lineplot(data=sales_data, x='order_date', y='total_orders', marker='o', color='green')
plt.title('Total Orders Over Time')
plt.xlabel('Order Date')
plt.ylabel('Total Orders')
plt.xticks(rotation=45)
plt.tight_layout()
plt.show()

# Query top products by revenue
product_query = '''
SELECT p.product_name, SUM(s.total_price) as total_revenue
FROM stg_sales s
JOIN stg_products p ON s.product_id = p.product_id
GROUP BY p.product_name
ORDER BY total_revenue DESC
LIMIT 10;
'''
product_data = pd.read_sql(product_query, engine)

# Plot top products by revenue
plt.figure(figsize=(10, 6))
sns.barplot(data=product_data, x='total_revenue', y='product_name', palette='Blues_d')
plt.title('Top 10 Products by Revenue')
plt.xlabel('Total Revenue ($)')
plt.ylabel('Product')
plt.tight_layout()
plt.show()
