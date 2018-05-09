# /lastest/www/menu.tcl
ad_page_contract {
    Left Menu
    @author Hector Amado (hr_amado@viaro.net)
    @creation-date 24-03-2006

} {
{ itemId "" }
{ object "" }
{ newURL ""}
} -properties {
} -validate {
} -errors {
}

set user_id [ad_maybe_redirect_for_registration]

# Communities that I belong to
db_multirow -extend {} communities select_communities "
   select dotlrn_communities_all.community_id,
          dotlrn_community__url(dotlrn_communities_all.community_id) as url,
          pretty_name
   from
          dotlrn_communities_all, dotlrn_member_rels_approved
   where
          dotlrn_communities_all.community_id = dotlrn_member_rels_approved.community_id and
          dotlrn_member_rels_approved.user_id = :user_id and archived_p='f'
" {
}

# List of pkg_ids
set communities_list [db_list communities_all_select  "                   
   select dotlrn_communities_all.package_id
   from
          dotlrn_communities_all, dotlrn_member_rels_approved
   where
          dotlrn_communities_all.community_id = dotlrn_member_rels_approved.community_id and
          dotlrn_member_rels_approved.user_id = :user_id and archived_p='f'
"]


set packages_names [list]
set objects [list]
set packages  [list]

foreach community $communities_list {
    set snode [site_node::get_node_id_from_object_id -object_id $community]
    foreach package [site_node::get_children -all -node_id $snode -element package_id] {
	if {![empty_string_p $package] } {
	    lappend packages $package
	}
    }
}


if {![llength $packages] == 0 } {
    set pkgs_ids [join $packages ,]
    latest::forums -pkgs_ids $pkgs_ids
    latest::fs -pkgs_ids $pkgs_ids
    latest::asm -pkgs_ids $pkgs_ids

  # check is lors is installed, if its not, then do nothing.
  set is_lors [db_0or1row check_lors "select package_key, pretty_name, installed_p from apm_package_version_info where package_key = 'lors'"]

    if {$is_lors == 1} {
	latest::lors -pkgs_ids $pkgs_ids }
}

