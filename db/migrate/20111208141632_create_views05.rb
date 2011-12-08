class CreateViews05 < ActiveRecord::Migration
  def up
    execute <<-SQL
      drop view if exists v_invoices;
    SQL
    execute <<-SQL
      create view v_invoices as (
select
   case invoice_type when 0 then to_char(invoice_date, 'YY')||'/'|| registration_number else registration_number::text end as registration_number,
   operating_party_id,
   id,
   author_id,
   customer_name,
   person,
   address,
   currency,
   author,
   status,
   our_ref,
   your_ref,
   your_date,
   invoice_date,
   payment_term,
   discount,
   po_billing,
   subject,
   ending_details,
   created_at,
   updated_at,
   rate,
   apply_vat,
   date_paid,
   trunc(round(total_official_fee, 2), 2) as total_official_fee,
   trunc(round(total_attorney_fee, 2), 2) as total_attorney_fee,
   trunc(round(total_attorney_fee + total_official_fee, 2), 2) as subtotal,
   trunc(round(case apply_vat when true then (total_attorney_fee + total_official_fee) * 0.22 else 0 end, 2), 2)  as total_vat,
   trunc(round(case apply_vat when true then (total_attorney_fee + total_official_fee) * 1.22 else (total_attorney_fee + total_official_fee) end, 2), 2) as grand_total
from (
	select
	  author.operating_party_id,
	        i.id,
	        i.author_id,
	        cust.name as customer_name,
	        pers.first_name || ' ' || pers.last_name as person,
	        replace(addr.country || ', ' || addr.city || ', ' || addr.street || ', ' || addr.house_number || ', ' || addr.room_number || ', ' || addr.post_code || ', ' || addr.po_box, ', ,', '') as address,
	        curr.currency,
	        ai.first_name || ' ' || ai.last_name as author,
	        iss.name as status,
	        i.our_ref,
	        i.your_ref,
	        i.your_date,
	        i.invoice_date,
	        i.payment_term,
	        i.discount,
	        i.po_billing,
	        i.subject,
	        i.ending_details,
	        i.created_at,
	        i.updated_at,
	        er.rate,
	        i.apply_vat,
	        i.date_paid,
	        il.total_official_fee,
	        il.total_attorney_fee - coalesce(nullif(il.total_attorney_fee/100*i.discount, 0), 0) as total_attorney_fee,
	        doc.registration_number,
	        i.invoice_type
	      from
	        invoices i	left outer join (
	                  select p.id as party_id, c.id, co.name from customers c, parties p, companies co where c.party_id = p.id and p.id = co.party_id
	                    ) cust on i.customer_id = cust.id
	              left outer join (
	                  select i.id, i.first_name,  i.last_name from individuals i
	                    ) pers on i.individual_id = pers.id
	              left outer join (
	                  select c.name as country, a.city, a.street, a.house_number, a.room_number, a.post_code, a.po_box, a.party_id  from addresses a left outer join countries c on c.id = a.country_id
	                    ) addr on addr.party_id = i.address_id
	              left outer join (
	                  select curr.name as currency, curr.id  from currencies curr
	                    ) curr on i.currency_id = curr.id
	              left outer join (
	                  select * from exchange_rates
	                    ) er on i.exchange_rate_id = er.id and er.currency_id = i.currency_id
	              left outer join (
	              		select invoice_id, sum(total_official_fee) as total_official_fee, sum(total_attorney_fee) as total_attorney_fee from (
	              		select invoice_id,
	              		sum(total_official_fee) as total_official_fee,
	              		sum(total_attorney_fee) as total_attorney_fee
	              		from invoice_lines group by invoice_id, total_discount, items
	              		) k group by invoice_id) il on il.invoice_id = i.id,
	        users author,
	        individuals ai,
	        invoice_statuses iss,
	        documents doc
	      where
	        i.author_id = author.id and
	        author.individual_id = ai.id and
	        iss.id = i.invoice_status_id and
	        doc.id = i.document_id
	      order by i.id) a
);
    SQL
  end

  def down
  end
end
