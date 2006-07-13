# Tcl callback proc implementations

ad_proc -public -callback subsite::get_extra_headers -impl latest {} {
    return the stuff to run well in the latest frame viewer
} {
    set scripts {
<script type="text/javascript">

function hide_headers(){
    if (top.location != location) { 
	var siteheader=document.getElementById?document.getElementById("site-header"):null;
	siteheader.style.display='none';
	var contextbar=document.getElementById?document.getElementById("context-bar"):null;
	contextbar.style.display='none';
	var navbarx=document.getElementById?document.getElementById("navbarx"):null;
	navbarx.style.display='none';
	document.getElementById("pre-page-body").innerHTML="<span id=\"addc1\" style=\"align:left;display:;position:absolute;top:0px;left:0px;\"> \n<a href=\"\#\" onClick=\"return _tp(false)\" title=\"Hide panel\" class=\"show-hide-icon_link\"><img src=\"/latest/resources/ico_hide.gif\" alt=\"Hide\" width=\"21\" height=\"23\" border=\"0\" align=\"top\"/></a> \n</span> \n<span id=\"addc\" style=\"align:left;display:none;position:absolute;top:0px;left:0px;\"> \n<a href=\"\#\" onClick=\"return _tp(true)\" title=\"Show panel\" class=\"show-hide-icon_link\"><img src=\"/latest/resources/ico_show.gif\" alt=\"Show\" width=\"21\" height=\"23\" border=\"0\" align=\"top\"/></a> \n</span> \n";
    } else {
	document.getElementById("pre-navbar").innerHTML="<span style=\"align:right;position:absolute;right:20px;\"><a class=\"button\" href=\"/latest\">Latest Stuff</a> \n</span> \n";
    }
    return false;
}

</script>

<script type="text/javascript">
<!--
function _gel(a){return document.getElementById?document.getElementById(a):null}

function _tp(a){
   var ab=_gel("addc");
   var ac=_gel("addc1");

   if (a) {
     ai=''; 
     aj='none';
     parent.document.getElementById('latest').cols='250,*';
   } else {
     ai='none';
     aj='';
     parent.document.getElementById('latest').cols='0%,100%';
   }

   ac.style.display=ai;
   ab.style.display=aj;
   
   return false;
}
// -->
</script>

}

    return $scripts
}

ad_proc -public -callback subsite::header_onload -impl latest {} {
    return the function to load when the page is served
} {

    return {hide_headers();}

}
