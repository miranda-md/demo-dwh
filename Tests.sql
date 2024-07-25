-- Test group 1: target table doesn’t contain duplicates.
SELECT 
    COUNT(*) AS total_rows,
    COUNT(DISTINCT CONCAT(product_id, '_', transaction_id)) AS unique_ids, -- columns for uniqueness
    COUNT(*) - COUNT(DISTINCT CONCAT(product_id, '_', transaction_id)) AS duplicate_count
FROM bl_3nf.bl_3nf_ce_product_transactions;


-- Test group 2: all records from SA layer are represented in the business layer.

CREATE OR REPLACE PROCEDURE bl_cl.compare_sa_3nf_counts()
AS $$
DECLARE
    sa_count_card INT;
    sa_count_cash INT;
    business_3nf_count INT;
    status TEXT;
BEGIN
    -- calculate count from SA layer for card sales
    SELECT COUNT(*) INTO sa_count_card
    FROM sa_coffee_shop_card_sales.src_coffee_shop_card;
    
    -- calculate count from SA layer for cash sales
    SELECT COUNT(*) INTO sa_count_cash
    FROM sa_coffee_shop_cash_sales.src_coffee_shop_cash;
    
    -- calculate count from business 3NF layer
    SELECT COUNT(*) INTO business_3nf_count
    FROM bl_3nf.bl_3nf_ce_product_transactions;
    
    -- compare counts and set status
    IF (sa_count_card + sa_count_cash) = business_3nf_count THEN
        status := 'All SA layer records are represented in 3 NF business layer';
    ELSE
        status := 'Mismatch: Check SA records';
    END IF;
    
    -- Return results
    RAISE NOTICE 'SA Count (Card Sales): %', sa_count_card;
    RAISE NOTICE 'SA Count (Cash Sales): %', sa_count_cash;
	RAISE NOTICE 'SA Count (Total): %', sa_count_card + sa_count_cash;
    RAISE NOTICE 'Business Layer Count: %', business_3nf_count;
    RAISE NOTICE 'Status: %', status;
END;
$$ LANGUAGE plpgsql;

CALL bl_cl.compare_sa_3nf_counts();