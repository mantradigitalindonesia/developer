-- PostgreSQL Row Level Security for Multi-Tenant Data Isolation and Schema Segregation

-- Step 1: Enable Row Level Security for the table
ALTER TABLE your_table_name ENABLE ROW LEVEL SECURITY;

-- Step 2: Create policies for your tenants
CREATE POLICY tenant_isolation_policy ON your_table_name
  FOR ALL
  USING (tenant_id = current_setting('app.current_tenant')); 

-- Step 3: Set the current tenant id before each query
SELECT set_config('app.current_tenant', 'your_tenant_id_here', true);

-- Step 4: Create a function to set current tenant
CREATE OR REPLACE FUNCTION set_current_tenant(tenant_id TEXT) RETURNS VOID AS $$
BEGIN
  PERFORM set_config('app.current_tenant', tenant_id, true);
END; $$ LANGUAGE plpgsql;

-- Usage example:
-- CALL set_current_tenant('tenant_1');

-- Step 5: Revoke permissions for non-tenants (if necessary)
REVOKE SELECT ON your_table_name FROM public;