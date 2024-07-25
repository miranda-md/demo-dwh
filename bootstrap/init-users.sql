CREATE USER bl_cl_user WITH PASSWORD 'password' LOGIN;

GRANT CONNECT ON DATABASE coffee_shop_sales TO bl_cl_user;

GRANT USAGE ON SCHEMA bl_cl TO bl_cl_user;