# Procs for each type of application

namespace eval latest {}

ad_proc -public latest::forums {
    -pkgs_ids
} {
    Gets all the forums from X time to now.
} {


    set limit [parameter::get_from_package_key -parameter LinksPerApplication -package_key "latest"]
    db_multirow -upvar_level 1 forums forums_select "
    select o.title, o.object_id, t.pretty_name as object_type, to_char(o.last_modified, 'MM-DD-YYYY') as last_modified
    from acs_object_types t, acs_objects o
    where t.object_type = o.object_type and
    o.object_type in ('forums_forum','forums_message')
    and o.package_id in ($pkgs_ids) order by last_modified desc limit $limit " 

}

ad_proc -public latest::fs {
    -pkgs_ids
} {
    Gets all the file storage objects from X time to now.
} {


    set limit [parameter::get_from_package_key -parameter LinksPerApplication -package_key "latest"]

    db_multirow -upvar_level 1 fs fs_select "
    select o.title, o.object_id, t.pretty_name as object_type, to_char(o.last_modified, 'MM-DD-YYYY') as last_modified
    from acs_object_types t, acs_objects o
    where t.object_type = o.object_type and
    o.object_type in ('file_storage_object')
    and o.package_id in ($pkgs_ids) order by last_modified desc limit $limit " 

}


ad_proc -public latest::asm {
    -pkgs_ids
} {
    Gets all the assessment objects from X time to now.
} {

    set user_id [ad_conn user_id]

    set limit [parameter::get_from_package_key -parameter LinksPerApplication -package_key "latest"]
    set old_comm_node_id 0
    db_multirow -upvar_level 1 -extend { assessment_url } assessment_sessions answered_assessments "
	select cr.item_id as assessment_id, cr.title, a.password,
	       to_char(a.start_time, 'YYYY-MM-DD HH24:MI:SS') as start_time,
	       to_char(a.end_time, 'YYYY-MM-DD HH24:MI:SS') as end_time,
	       to_char(now(), 'YYYY-MM-DD HH24:MI:SS') as cur_time,
               to_char(cr.publish_date, 'MM-DD-YYYY') as publish_date,
	       sc.node_id as comm_node_id, sa.node_id as as_node_id
	from as_assessments a, cr_revisions cr, cr_items ci, cr_folders cf,
	     site_nodes sa, site_nodes sc, apm_packages p
	where a.assessment_id = cr.revision_id
	and cr.revision_id = ci.latest_revision
	and ci.parent_id = cf.folder_id
		and sa.object_id = cf.package_id
	and sc.node_id = sa.parent_id
     and cf.package_id in ($pkgs_ids)
	and p.package_id = sc.object_id
	and exists (select 1
		from as_assessment_section_map asm, as_item_section_map ism
		where asm.assessment_id = a.assessment_id
		and ism.section_id = asm.section_id)
	and acs_permission__permission_p (a.assessment_id, :user_id, 'read') = 't'
	order by publish_date desc limit $limit
 " {

     if {([empty_string_p $start_time] || $start_time <= $cur_time) && ([empty_string_p $end_time] || $end_time >= $cur_time)} {
	 set assessment_url [site_node::get_url -node_id $as_node_id]

	 if {[empty_string_p $password]} {
	     append assessment_url [export_vars -base "assessment" {assessment_id}]
	 } else {
	     append assessment_url [export_vars -base "assessment-password" {assessment_id}]
	 }

     }
 }

}


ad_proc -public latest::lors {
    -pkgs_ids
} {
    Gets all the lors objects from X time to now.
} {

    set user_id [ad_conn user_id]

    set limit [parameter::get_from_package_key -parameter LinksPerApplication -package_key "latest"]

    db_multirow -upvar_level 1 -extend { course_url } \
	d_courses select_d_courses "
           select 
	   cp.man_id,
           cp.course_name,
	   to_char(acs.creation_date, 'MM-DD-YYYY') as creation_date,
	   pf.folder_name,
	   pf.format_name,
           cpmc.lorsm_instance_id
	from
           ims_cp_manifests cp, 
	   acs_objects acs, 
           ims_cp_manifest_class cpmc, 
           lorsm_course_presentation_formats pf
	where 
           cp.man_id = acs.object_id
	and
           cp.man_id = cpmc.man_id
      and
         cpmc.lorsm_instance_id in ($pkgs_ids)
	and
           cpmc.isenabled = 't'
	and
	   pf.format_id = cp.course_presentation_format
	order by acs.creation_date desc limit $limit
" {
    set ims_md_id $man_id
    if { [string eq $format_name "default"] } {

	set context [site_node::get_url_from_object_id -object_id $lorsm_instance_id]
	if ([db_0or1row query "
    		select
           		cpr.man_id,
           		cpr.res_id,
           		case
              			when upper(scorm_type) = 'SCO' then 'delivery-scorm'
              			else 'delivery'
           		end as needscorte
    			from
           			ims_cp_resources cpr
    			where
				cpr.man_id = :man_id 
			order by cpr.scorm_type desc limit 1"
	    ]) {

	    set delivery_method $needscorte
	    
	    set course_url_url [export_vars -base "[lindex $context 0]$delivery_method" -url {man_id}]
	    set course_url "<a href=\"$course_url_url\" title=\"[_ lorsm.Access_Course]\" target=new>$course_name</a>" 
	    ns_log Debug "lorsm - course_url: $course_url"
	} else {
	    set course_url "NO RESOURCES ERROR"
	} 
    } else {
	set course_url "<a href=\"[site_node::get_url_from_object_id -object_id $lorsm_instance_id]${folder_name}/?[export_vars man_id]\" title=\"[_ lorsm.Access_Course]\" target=new>$course_name</a>" 
    }
}

}
