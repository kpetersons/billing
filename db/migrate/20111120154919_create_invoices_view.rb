class CreateInvoicesView < ActiveRecord::Migration
  def self.up
    execute <<-SQL
      create view v_invoices as (
        select
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
          i.date_paid
        from
          invoices i	left outer join (
                    select p.id as party_id, c.id, co.name from customers c, parties p, companies co where c.party_id = p.id and p.id = co.party_id
                      ) cust on i.customer_id = cust.id
                left outer join (
                    select i.id, i.first_name,  i.last_name from individuals i
                      ) pers on i.individual_id = pers.id
                left outer join (
                    select c.name as country, a.city, a.street, a.house_number, a.room_number, a.post_code, a.po_box, a.party_id  from addresses a left outer join countries c on c.id = a.country_id
                      ) addr on addr.party_id = cust.party_id
                left outer join (
                    select curr.name as currency, curr.id  from currencies curr
                      ) curr on i.currency_id = curr.id
                left outer join (
                    select * from exchange_rates
                      ) er on i.exchange_rate_id = er.id and er.currency_id = i.currency_id,
          users author,
          individuals ai,
          invoice_statuses iss
        where
          i.author_id = author.id and
          author.individual_id = ai.id and
          iss.id = i.invoice_status_id
        order by i.id);
    SQL
  end

  def self.down
    execute "drop view v_invoices"
  end
end
