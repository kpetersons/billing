class CreateViews03 < ActiveRecord::Migration
  def up
    execute <<-SQL
      drop view if exists v_matters;
    SQL
    execute <<-SQL
      create view v_matters as (
      select
        ma.operating_party_id,
        ma.agent_id,
        ma.applicant_id,
        ma.id,
        author.id as author_id,
        doc.parent_id,
        doc.registration_number,
        doc.description,
        doc.created_at,
        doc.updated_at,
        doc.notes,
        appl_company.name as applicant,
        agent_company.name as agent,
        author_individual.first_name || ' ' || author_individual.last_name as author,
        op_company.name as operating_party,
        mt.name as matter_type,
        ms.name as matter_status,
        t.wipo_number,
        t.priority_date,
        t.mark_name,
        t.ctm_number,
        t.cfe_index,
        COALESCE (t.appl_number,p.application_number,d.application_number) as application_number,
        COALESCE (t.appl_date, p.application_date, d.application_date) as application_date,
        p.patent_number,
        p.patent_grant_date,
        p.ep_appl_number,
        p.ep_number,
        d.design_number,
        d.rdc_appl_number,
        d.rdc_number,
        l.opposed_marks,
        l.instance,
        l.date_of_closure,
        l.opposite_party,
        l.opposite_party_agent,
        l.legal_type,
        c.date_of_order_alert,
        c.ca_application_date,
        c.ca_application_number,
        c.name as client_all_ip,
        ps.patent_eq_numbers,
        ps.no_of_patents,
        COALESCE (ps.date_of_order, s.date_of_order) as date_of_order,
        s.search_for,
        s.no_of_objects,
        s.express_search,
        dm.domain_name,
        dm.registration_date
      from
        documents doc,
        matters ma left outer join trademarks t on ma.id = t.matter_id
        left outer join patents p 			on ma.id = p.matter_id
        left outer join designs d 			on ma.id = d.matter_id
        left outer join (
                select
                  l.opposed_marks,
                  l.instance,
                  l.date_of_closure,
                  l.opposite_party_id,
                  l.opposite_party_agent_id,
                  lt.name as legal_type,
                  cop.name as opposite_party,
                  copa.name as opposite_party_agent,
                  l.matter_id
                from
                  legals l 	left outer join (select cop.id, coop.name from customers cop, parties pop, companies coop where cop.party_id = pop.id and pop.id = coop.party_id) cop on l.opposite_party_id = cop.id
                      left outer join (select copa.id, coopa.name from customers copa, parties popa, companies coopa where copa.party_id = popa.id and popa.id = coopa.party_id) copa on l.opposite_party_agent_id = copa.id	,
                  legal_types lt
                where
                  l.legal_type_id = lt.id
        ) l on ma.id = l.matter_id
        left outer join (
                select
                  c.date_of_order_alert,
                  c.ca_application_date,
                  c.ca_application_number,
                  copaip.name,
                  c.matter_id
                from
                  customs c left outer join customers caip on c.client_all_ip_id = caip.id, parties paip, companies copaip where paip.id = caip.party_id and copaip.party_id = paip.id) c on ma.id = c.matter_id
        left outer join patent_searches ps 	on ma.id = ps.matter_id
        left outer join searches s 			on ma.id = s.matter_id
        left outer join domains dm 			on ma.id = dm.matter_id,
        customers applicant,
        parties appl_party,
        companies appl_company,
        customers agent,
        parties agent_party,
        companies agent_company,
        users author,
        individuals author_individual,
        matter_types mt,
        operating_parties op,
        companies op_company,
        matter_statuses ms
      where
        doc.id = ma.document_id and
        ma.matter_type_id = mt.id and
        ma.matter_status_id = ms.id and
        ma.author_id = author.id and
        ma.applicant_id = applicant.orig_id and
        ma.agent_id = agent.orig_id and
        ma.operating_party_id = op.id and
        author.individual_id = author_individual.id and
        applicant.party_id = appl_party.id and
        agent.party_id = agent_party.id and
        applicant.date_effective_end is null and
        agent.date_effective_end is null and
        appl_party.id = appl_company.party_id and
        agent_party.id = agent_company.party_id and
        op.company_id = op_company.id
      order by ma.id
      );
    SQL
    execute <<-SQL
      drop view if exists v_invoices;
    SQL
    execute <<-SQL
create view v_invoices as (
select
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
   total_official_fee,
   total_attorney_fee,
   total_attorney_fee + total_official_fee as subtotal,
   case apply_vat when true then (total_attorney_fee + total_official_fee) * 0.22 else 0 end  as total_vat,
   case apply_vat when true then (total_attorney_fee + total_official_fee) * 1.22 else (total_attorney_fee + total_official_fee) end  as grand_total
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
	        il.total_attorney_fee - coalesce(nullif(il.total_attorney_fee/100*i.discount, 0), 0) as total_attorney_fee
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
	        invoice_statuses iss
	      where
	        i.author_id = author.id and
	        author.individual_id = ai.id and
	        iss.id = i.invoice_status_id
	      order by i.id) a
);
        SQL
  end

  def down
  end
end
