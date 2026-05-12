# -*- coding: utf-8 -*-
"""
Created on Mon May 11 20:02:46 2026

@author: ADMIN
"""

import streamlit as st
import pandas as pd
import mysql.connector
import plotly.express as px
import plotly.graph_objects as go

# ============================================
# PAGE CONFIGURATION
# ============================================

st.set_page_config(
    page_title="Smart Inventory & Supply Chain Dashboard",
    page_icon="📦",
    layout="wide"
)

# ============================================
# DATABASE CONNECTION
# ============================================

connection = mysql.connector.connect(
    host="localhost",
    user="root",
    password="2003",
    database="smart_inventory_supply_chain"
)

# ============================================
# FUNCTION TO LOAD DATA
# ============================================

@st.cache_data

def load_data(query):
    return pd.read_sql(query, connection)

# ============================================
# SIDEBAR
# ============================================

st.sidebar.title("📊 Dashboard Menu")

page = st.sidebar.radio(
    "Select Dashboard Section",
    [
        "Overview",
        "Inventory Analysis",
        "Sales Analysis",
        "Shipment Analysis",
        "Customer Analysis",
        "Supplier Analysis"
    ]
)

# ============================================
# TITLE
# ============================================

st.title("📦 Smart Inventory & Supply Chain Dashboard")
st.markdown("### Built using MySQL + Streamlit")

# ============================================
# OVERVIEW PAGE
# ============================================

if page == "Overview":

    total_products = load_data(
        "SELECT COUNT(*) AS total FROM Products"
    )['total'][0]

    total_customers = load_data(
        "SELECT COUNT(*) AS total FROM Customers"
    )['total'][0]

    total_orders = load_data(
        "SELECT COUNT(*) AS total FROM Orders"
    )['total'][0]

    total_revenue = load_data(
        "SELECT SUM(total_price) AS revenue FROM Order_Items"
    )['revenue'][0]

    col1, col2, col3, col4 = st.columns(4)

    col1.metric("Total Products", total_products)
    col2.metric("Total Customers", total_customers)
    col3.metric("Total Orders", total_orders)
    col4.metric("Total Revenue", f"₹ {round(total_revenue,2)}")

    st.markdown("---")

    st.subheader("📈 Monthly Sales Trend")

    monthly_sales = load_data(
        """
        SELECT MONTH(o.order_date) AS month_number,
               SUM(oi.total_price) AS sales
        FROM Orders o
        JOIN Order_Items oi
        ON o.order_id = oi.order_id
        GROUP BY MONTH(o.order_date)
        ORDER BY month_number
        """
    )

    fig = px.line(
        monthly_sales,
        x='month_number',
        y='sales',
        markers=True,
        title='Monthly Sales Trend'
    )

    st.plotly_chart(fig, use_container_width=True)

# ============================================
# INVENTORY ANALYSIS
# ============================================

elif page == "Inventory Analysis":

    st.subheader("📦 Low Stock Products")

    low_stock = load_data(
        """
        SELECT p.product_name,
               i.stock_quantity,
               i.reorder_level,
               w.warehouse_name
        FROM Inventory i
        JOIN Products p
        ON i.product_id = p.product_id
        JOIN Warehouses w
        ON i.warehouse_id = w.warehouse_id
        WHERE i.stock_quantity < i.reorder_level
        """
    )

    st.dataframe(low_stock)

    st.subheader("🏬 Warehouse Stock Distribution")

    warehouse_stock = load_data(
        """
        SELECT w.warehouse_name,
               SUM(i.stock_quantity) AS total_stock
        FROM Inventory i
        JOIN Warehouses w
        ON i.warehouse_id = w.warehouse_id
        GROUP BY w.warehouse_name
        """
    )

    fig = px.bar(
        warehouse_stock,
        x='warehouse_name',
        y='total_stock',
        title='Warehouse Stock Distribution'
    )

    st.plotly_chart(fig, use_container_width=True)

# ============================================
# SALES ANALYSIS
# ============================================

elif page == "Sales Analysis":

    st.subheader("💰 Top Selling Products")

    top_products = load_data(
        """
        SELECT p.product_name,
               SUM(oi.quantity) AS quantity_sold,
               SUM(oi.total_price) AS revenue
        FROM Order_Items oi
        JOIN Products p
        ON oi.product_id = p.product_id
        GROUP BY p.product_name
        ORDER BY revenue DESC
        LIMIT 10
        """
    )

    st.dataframe(top_products)

    fig = px.bar(
        top_products,
        x='product_name',
        y='revenue',
        title='Top 10 Revenue Generating Products'
    )

    st.plotly_chart(fig, use_container_width=True)

    st.subheader("📊 Category Wise Revenue")

    category_revenue = load_data(
        """
        SELECT p.category,
               SUM(oi.total_price) AS revenue
        FROM Products p
        JOIN Order_Items oi
        ON p.product_id = oi.product_id
        GROUP BY p.category
        """
    )

    fig2 = px.pie(
        category_revenue,
        names='category',
        values='revenue',
        title='Category Wise Revenue'
    )

    st.plotly_chart(fig2, use_container_width=True)

# ============================================
# SHIPMENT ANALYSIS
# ============================================

elif page == "Shipment Analysis":

    st.subheader("🚚 Delayed Shipments")

    delayed_shipments = load_data(
        """
        SELECT shipment_id,
               order_id,
               shipped_date,
               delivery_date,
               DATEDIFF(delivery_date, shipped_date) AS delivery_days
        FROM Shipments
        WHERE DATEDIFF(delivery_date, shipped_date) > 7
        """
    )

    st.dataframe(delayed_shipments)

    st.subheader("📦 Shipment Delivery Days")

    shipment_days = load_data(
        """
        SELECT shipment_id,
               DATEDIFF(delivery_date, shipped_date) AS delivery_days
        FROM Shipments
        """
    )

    fig = px.histogram(
        shipment_days,
        x='delivery_days',
        nbins=15,
        title='Shipment Delivery Distribution'
    )

    st.plotly_chart(fig, use_container_width=True)

# ============================================
# CUSTOMER ANALYSIS
# ============================================

elif page == "Customer Analysis":

    st.subheader("👥 Top Customers")

    customer_analysis = load_data(
        """
        SELECT c.customer_name,
               SUM(oi.total_price) AS total_spending
        FROM Customers c
        JOIN Orders o
        ON c.customer_id = o.customer_id
        JOIN Order_Items oi
        ON o.order_id = oi.order_id
        GROUP BY c.customer_name
        ORDER BY total_spending DESC
        LIMIT 10
        """
    )

    st.dataframe(customer_analysis)

    fig = px.bar(
        customer_analysis,
        x='customer_name',
        y='total_spending',
        title='Top Customers by Spending'
    )

    st.plotly_chart(fig, use_container_width=True)

    st.subheader("🧾 Customer Segment Distribution")

    segment_data = load_data(
        """
        SELECT segment,
               COUNT(*) AS total_customers
        FROM Customers
        GROUP BY segment
        """
    )

    fig2 = px.pie(
        segment_data,
        names='segment',
        values='total_customers',
        title='Customer Segments'
    )

    st.plotly_chart(fig2, use_container_width=True)

# ============================================
# SUPPLIER ANALYSIS
# ============================================

elif page == "Supplier Analysis":

    st.subheader("🏭 Supplier Performance")

    supplier_data = load_data(
        """
        SELECT s.supplier_name,
               COUNT(p.product_id) AS total_products,
               AVG(s.rating) AS average_rating
        FROM Suppliers s
        JOIN Products p
        ON s.supplier_id = p.supplier_id
        GROUP BY s.supplier_name
        ORDER BY total_products DESC
        LIMIT 10
        """
    )

    st.dataframe(supplier_data)

    fig = px.bar(
        supplier_data,
        x='supplier_name',
        y='total_products',
        title='Top Suppliers by Product Count'
    )

    st.plotly_chart(fig, use_container_width=True)

# ============================================
# FOOTER
# ============================================

st.markdown("---")
st.markdown("### 🚀 SQL + Streamlit Supply Chain Dashboard")
st.markdown("Developed using MySQL, Python, Streamlit and Plotly")
