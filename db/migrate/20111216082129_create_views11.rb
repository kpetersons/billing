class CreateViews11 < ActiveRecord::Migration
  def up
    execute <<-SQL
      drop view if exists v_matter_tasks;
    SQL
    execute <<-SQL
      drop view if exists v_matters;
    SQL

    execute <<-SQL
   create view v_matters as (
      select
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
        appl_company.name as applicant,
        agent_company.name as agent,
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
        left outer join (select array_agg(c.code::integer)::text as classes, mc.matter_id from matter_clazzs mc, clazzs c where mc.clazz_id = c.id group by mc.matter_id) cl on ma.id = cl.matter_id,
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
      create view v_matter_tasks as (
        select
          mt.id,
          mt.matter_id,
          m.registration_number,
          m.matter_type,
          mtt.name as task_type,
          mts.name as status,
          substring(mt.description from 1 for 150) as description,
          mt.proposed_deadline as deadline,
          mt.created_at,
          mt.updated_at
        from
          matter_tasks mt,
          v_matters m,
          matter_task_statuses mts,
          matter_task_types mtt
        where
          mt.matter_id = m.id
          and mts.id = mt.matter_task_status_id
          and mtt.id = mt.matter_task_type_id
      );
    SQL
  end

  def down
  end
end
