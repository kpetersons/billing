class AddImageToVMatter23 < ActiveRecord::Migration
  def up
    execute <<-SQL
      drop view if exists v_invoices;
    SQL

    execute <<-SQL
     create or replace view v_matters as (
      select
        mim.image_exists,
        ma.matter_type_id,
        ma.operating_party_id,
        ma.agent_id,
        ma.applicant_id,
        ma.id,
        author.id as author_id,
        doc.parent_id,
        case COALESCE(doc.parent_id, -1) when -1 then doc.registration_number else parent.registration_number || '/' || doc.registration_number end as registration_number,
        doc.description,
        doc.created_at,
        doc.updated_at,
        doc.notes,
        applicant.name as applicant,
        agent.name as agent,
        author_individual.first_name || ' ' || author_individual.last_name as author,
        op_company.name as operating_party,
        mt.name as matter_type,
        ms.name as matter_status,
        cl.classes,
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
        l.court_ref,
        c.vid_ref,
        c.date_of_order_alert,
        c.ca_application_date,
        c.ca_application_number,
        c.name as client_all_ip,
        ps.patent_eq_numbers,
        ps.no_of_patents,
        COALESCE (ps.date_of_order, s.date_of_order, l.date_of_order) as date_of_order,
        s.search_for,
        s.no_of_objects,
        s.express_search,
        dm.domain_name,
        COALESCE(dm.registration_date, t.registration_date, p.registration_date, d.registration_date) as registration_date,
        l.opposite_party_id,
        l.opposite_party_agent_id,
        t.reg_number as tm_registration_number
      from
        documents doc left outer join documents parent on doc.parent_id = parent.id,
        matters ma left outer join trademarks t on ma.id = t.matter_id
        left outer join patents p 			on ma.id = p.matter_id
        left outer join designs d 			on ma.id = d.matter_id
	  LEFT JOIN (select matter_id, 'Y'::text as image_exists from matter_images group by matter_id) mim ON (ma.id = mim.matter_id)
        left outer join (
                select
                  l.opposed_marks,
                  l.instance,
                  l.date_of_closure,
                  l.opposite_party_id,
                  l.opposite_party_agent_id,
                  l.date_of_order,
                  l.court_ref,
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
        	select appl.orig_id, appl_c.name from customers appl, companies appl_c where appl.party_id = appl_c.party_id and appl.date_effective_end is null
        ) applicant on applicant.orig_id = ma.applicant_id
        left outer join (
        	select ag.orig_id, ag_c.name from customers ag, companies ag_c where ag.party_id = ag_c.party_id and ag.date_effective_end is null
        ) agent on agent.orig_id = ma.agent_id
        left outer join (
                select
                  c.date_of_order_alert,
                  c.ca_application_date,
                  c.ca_application_number,
                  c.vid_ref,
                  copaip.name,
                  c.matter_id
                from
                  customs c left outer join customers caip on c.client_all_ip_id = caip.id, parties paip, companies copaip where paip.id = caip.party_id and copaip.party_id = paip.id) c on ma.id = c.matter_id
        left outer join patent_searches ps 	on ma.id = ps.matter_id
        left outer join searches s 			on ma.id = s.matter_id
        left outer join domains dm 			on ma.id = dm.matter_id
        left outer join (select trim(overlay(overlay(classes placing ' ' from 1) placing ' ' from length(overlay(classes placing ' ' from 1)))) as classes, matter_id  from (
			select array_agg(CAST(c.code AS integer))::text as classes, mc.matter_id FROM MATTER_clazzs mc, clazzs c where c.id = mc.clazz_id group by mc.matter_id) c) cl on ma.id = cl.matter_id,
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
        ma.operating_party_id = op.id and
        author.individual_id = author_individual.id and
        op.company_id = op_company.id
      order by ma.id
    );
    SQL

    execute <<-SQL
     create or replace view v_invoices as (
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
   trunc(round(case invoice_type = 1 when true then case apply_vat when true then (total_attorney_fee + total_official_fee) * vat_rate else 0 end else (total_attorney_fee) * vat_rate end, 2), 2) as total_vat,
   trunc(round(case invoice_type = 1 when true then case apply_vat when true then (total_attorney_fee + total_official_fee) * (vat_rate + 1) else (total_attorney_fee + total_official_fee) end else (total_attorney_fee) * (vat_rate + 1) + total_official_fee end, 2), 2) as grand_total,
   trunc(round(total_attorney_fee, 2), 2) as total_attorney_fee,
   total_discount,
   matter_type_id,
   author_name as issued_by
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
	        iss.id as invoice_status_id,
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
	        il.total_attorney_fee - total_discount as total_attorney_fee,
	        il.total_discount,
	        doc.registration_number,
	        i.invoice_type,
	        i.matter_type_id,
	        i.author_name,
	        vat_rate.vat_rate
	      from
	        invoices i	left outer join (
	                  select p.id as party_id, c.id, co.name from customers c, parties p, companies co where c.party_id = p.id and p.id = co.party_id
	                    ) cust on i.customer_id = cust.id
	              left outer join (
	                  select i.id, i.first_name,  i.last_name from individuals i
	                    ) pers on i.individual_id = pers.id
	              left outer join (
	                  select c.name as country, a.city, a.street, a.house_number, a.room_number, a.post_code, a.po_box, a.id  from addresses a left outer join countries c on c.id = a.country_id
	                    ) addr on addr.id = i.address_id
	              left outer join (
	                  select curr.name as currency, curr.id  from currencies curr
	                    ) curr on i.currency_id = curr.id
	              left outer join (
	                  select * from exchange_rates
	                    ) er on i.exchange_rate_id = er.id and er.currency_id = i.currency_id
	              left outer join (
	              		select invoice_id, sum(total_official_fee) as total_official_fee, sum(total_attorney_fee) as total_attorney_fee, sum(total_discount) as total_discount from (
	              		select invoice_id,
	              		sum(total_official_fee) as total_official_fee,
	              		sum(total_attorney_fee) as total_attorney_fee,
	              		sum(total_discount) as total_discount
	              		from invoice_lines group by invoice_id, items
	              		) k group by invoice_id) il on il.invoice_id = i.id
	              left outer join (
	              		select id, vat_rate from billing_settings
	              ) vat_rate on vat_rate.id = i.billing_settings_id,
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
